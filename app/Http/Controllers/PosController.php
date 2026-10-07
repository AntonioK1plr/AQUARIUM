<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use App\Models\Pedido;
use App\Models\PedidoItem;
use App\Models\CorteCaja;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Str;

class PosController extends Controller
{
    public function index()
    {
        $productos = Producto::where('estatus', true)->where('stock', '>', 0)->get();
        return Inertia::render('Pos/Index', [
            'productos' => $productos,
        ]);
    }

    // RF-18: Búsqueda y escaneo por código de barras o ID (< 0.5s)
    public function buscarProducto(Request $request)
    {
        $query = $request->input('q');
        $producto = Producto::where('id', $query)
            ->orWhere('nombre', 'ilike', '%' . $query . '%')
            ->first();

        if (!$producto) {
            return response()->json(['error' => 'Producto no encontrado.'], 404);
        }

        return response()->json($producto);
    }

    // RF-19: Recuperación de pedido Click & Collect por escaneo de Pase QR
    public function buscarPorQr(Request $request)
    {
        $codigoQr = $request->input('codigo_qr');
        $pedido = Pedido::with(['user', 'items.producto'])
            ->where('codigo_qr_pase', $codigoQr)
            ->first();

        if (!$pedido) {
            return response()->json(['error' => 'Pase QR no valido o inexistente.'], 404);
        }

        return response()->json($pedido);
    }

    // RF-20, RF-21, RF-22, RF-23: Cobro en caja, descuento de stock y emisión de ticket fiscal
    public function procesarCobro(Request $request)
    {
        $request->validate([
            'items' => 'required|array|min:1',
            'items.*.producto_id' => 'required|exists:productos,id',
            'items.*.cantidad' => 'required|integer|min:1',
            'metodo_pago' => 'required|in:efectivo,tarjeta',
            'monto_recibido' => 'required_if:metodo_pago,efectivo|numeric|nullable',
        ]);

        $subtotal = 0;
        $itemsProcesar = [];

        foreach ($request->items as $itemData) {
            $producto = Producto::findOrFail($itemData['producto_id']);

            if ($producto->stock < $itemData['cantidad']) {
                return redirect()->back()->withErrors([
                    'stock' => "Stock insuficiente para: {$producto->nombre}. Disponible: {$producto->stock}"
                ]);
            }

            $lineaSubtotal = $producto->precio * $itemData['cantidad'];
            $subtotal += $lineaSubtotal;

            $itemsProcesar[] = [
                'producto' => $producto,
                'cantidad' => $itemData['cantidad'],
                'precio_unitario' => $producto->precio,
                'subtotal' => $lineaSubtotal,
            ];
        }

        // RF-23: Desglose de 16% IVA
        $iva = $subtotal * 0.16;
        $total = $subtotal + $iva;

        // RF-20: Cálculo de cambio en efectivo
        $montoRecibido = $request->metodo_pago === 'efectivo' ? floatval($request->monto_recibido) : $total;
        $cambio = $montoRecibido - $total;

        if ($request->metodo_pago === 'efectivo' && $cambio < 0) {
            return redirect()->back()->withErrors(['monto_recibido' => 'El monto recibido es menor al total a pagar.']);
        }

        // Crear Pedido POS
        $pedido = Pedido::create([
            'folio' => 'POS-' . strtoupper(Str::random(8)),
            'user_id' => auth()->id(),
            'subtotal' => $subtotal,
            'iva' => $iva,
            'total' => $total,
            'metodo_entrega' => 'click_collect',
            'estatus_pago' => 'pagado',
            'estatus_pedido' => 'completado',
            'carta_responsiva_firmada' => true,
        ]);

        foreach ($itemsProcesar as $item) {
            PedidoItem::create([
                'pedido_id' => $pedido->id,
                'producto_id' => $item['producto']->id,
                'cantidad' => $item['cantidad'],
                'precio_unitario' => $item['precio_unitario'],
                'subtotal' => $item['subtotal'],
            ]);

            // RF-22: Descuento de stock en tiempo real
            $item['producto']->decrement('stock', $item['cantidad']);
        }

        return redirect()->back()->with([
            'success' => 'Venta completada en POS.',
            'ticket' => [
                'folio' => $pedido->folio,
                'subtotal' => number_format($subtotal, 2),
                'iva' => number_format($iva, 2),
                'total' => number_format($total, 2),
                'metodo_pago' => $request->metodo_pago,
                'monto_recibido' => number_format($montoRecibido, 2),
                'cambio' => number_format($cambio, 2),
                'fecha' => now()->format('Y-m-d H:i:s'),
            ]
        ]);
    }

    // RF-24: Reporte y Corte de Caja Z
    public function corteCaja(Request $request)
    {
        $request->validate([
            'monto_inicial' => 'required|numeric|min:0',
            'observaciones' => 'nullable|string|max:500',
        ]);

        $ventasEfectivo = Pedido::where('user_id', auth()->id())
            ->where('estatus_pago', 'pagado')
            ->whereDate('created_at', now()->toDateString())
            ->sum('total');

        $totalCaja = $request->monto_inicial + $ventasEfectivo;

        CorteCaja::create([
            'user_id' => auth()->id(),
            'monto_inicial' => $request->monto_inicial,
            'ventas_efectivo' => $ventasEfectivo,
            'ventas_tarjeta' => 0.00,
            'total_caja' => $totalCaja,
            'diferencia' => 0.00,
            'observaciones' => $request->observaciones,
        ]);

        return redirect()->back()->with('success', 'Corte de Caja Z generado correctamente.');
    }
}
