<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\CarritoItem;
use App\Models\Pedido;
use App\Models\PedidoItem;
use App\Services\CompatibilidadBiologicaService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;


class CheckoutController extends Controller
{
    protected $compatibilidadService;

    public function __construct(CompatibilidadBiologicaService $compatibilidadService)
    {
        $this->compatibilidadService = $compatibilidadService;
    }

    public function procesar(Request $request)
    {
        $request->validate([
            'metodo_entrega' => 'required|in:click_collect,envio_domicilio',
            'acepta_carta_responsiva' => 'boolean',
        ]);

        $items = CarritoItem::with('producto')
            ->where('user_id', $request->user()->id)
            ->get();

        if ($items->isEmpty()) {
            return back()->withErrors(['carrito' => 'El carrito esta vacio.']);
        }

        $productos = $items->pluck('producto');
        $evaluacion = $this->compatibilidadService->evaluarCompatibilidad($productos);

        if ($evaluacion['requiere_carta_responsiva'] && !$request->acepta_carta_responsiva) {
            return back()->withErrors([
                'carta' => 'Debe firmar digitalmente la Carta Responsiva de Incompatibilidad Biologica para continuar.'
            ]);
        }

        DB::beginTransaction();
        try {
            $subtotal = $items->sum(fn($i) => $i->producto->precio * $i->cantidad);
            $iva = $subtotal * 0.16;
            $total = $subtotal + $iva;

            $folio = 'AQUA-' . strtoupper(Str::random(8));

            $pedido = Pedido::create([
                'folio' => $folio,
                'user_id' => $request->user()->id,
                'subtotal' => $subtotal,
                'iva' => $iva,
                'total' => $total,
                'metodo_entrega' => $request->metodo_entrega,
                'estatus_pago' => 'pagado',
                'estatus_pedido' => 'en_picking',
                'carta_responsiva_firmada' => $request->acepta_carta_responsiva ?? false,
                'codigo_qr_pase' => 'QR-' . $folio,
                'expira_at' => now()->addHours(48), // BR-007
            ]);

            foreach ($items as $item) {
                PedidoItem::create([
                    'pedido_id' => $pedido->id,
                    'producto_id' => $item->producto_id,
                    'cantidad' => $item->cantidad,
                    'precio_unitario' => $item->producto->precio,
                    'subtotal' => $item->producto->precio * $item->cantidad,
                ]);

                // Descontar inventario
                $item->producto->decrement('stock', $item->cantidad);
            }

            // Vaciar carrito
            CarritoItem::where('user_id', $request->user()->id)->delete();

            DB::commit();

            return redirect()->route('productos.index')->with('success', 'Pedido creado exitosamente con folio ' . $folio);

        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => 'Error al procesar el pedido: ' . $e->getMessage()]);
        }
    }
}
