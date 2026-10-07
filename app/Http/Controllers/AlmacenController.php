<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Pedido;
use App\Models\Producto;
use App\Models\Merma;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Carbon\Carbon;


class AlmacenController extends Controller
{
    public function index()
    {
        // RF-25: Consulta de ordenes pendientes de picking
        $pedidosPicking = Pedido::with(['user', 'items.producto'])
            ->whereIn('estatus_pedido', ['pendiente', 'en_picking', 'listo_para_recoleccion'])
            ->latest()
            ->get();

        $productos = Producto::where('estatus', true)->get();

        return Inertia::render('Almacen/Index', [
            'pedidos' => $pedidosPicking,
            'productos' => $productos,
        ]);
    }

    // RF-26: Confirmación de pedido preparado
    public function marcarListo(Request $request, $id)
    {
        $pedido = Pedido::findOrFail($id);
        $pedido->update([
            'estatus_pedido' => 'listo_para_recoleccion',
            'expira_at' => Carbon::now()->addHours(48), // BR-007: Expiración a las 48h
        ]);

        return redirect()->back()->with('success', 'Pedido marcado como Listo en Mostrador.');
    }

    // RF-27 / BR-007: Liberación manual/automática de pedidos expirados (>48h)
    public function liberarExpirados()
    {
        $expirados = Pedido::where('estatus_pedido', 'listo_para_recoleccion')
            ->where('expira_at', '<', Carbon::now())
            ->get();

        foreach ($expirados as $pedido) {
            foreach ($pedido->items as $item) {
                // Devolver stock al inventario
                $producto = Producto::find($item->producto_id);
                if ($producto) {
                    $producto->increment('stock', $item->cantidad);
                }
            }
            $pedido->update(['estatus_pedido' => 'cancelado']);
        }

        return redirect()->back()->with('success', 'Se liberaron los pedidos expirados y se devolvió el stock.');
    }

    // RF-28: Registro y sincronización de mermas/bajas biológicas
    public function registrarMerma(Request $request)
    {
        $request->validate([
            'producto_id' => 'required|exists:productos,id',
            'cantidad' => 'required|integer|min:1',
            'motivo' => 'required|in:mortalidad_biologica,daño_equipo,caducidad_insumo,ajuste_inventario',
            'observaciones' => 'nullable|string|max:500',
        ]);

        $producto = Producto::findOrFail($request->producto_id);

        if ($producto->stock < $request->cantidad) {
            return redirect()->back()->withErrors(['cantidad' => 'La cantidad supera el stock disponible.']);
        }

        // Descontar stock por merma
        $producto->decrement('stock', $request->cantidad);

        Merma::create([
            'producto_id' => $producto->id,
            'user_id' => auth()->id(),
            'cantidad' => $request->cantidad,
            'motivo' => $request->motivo,
            'observaciones' => $request->observaciones,
        ]);

        return redirect()->back()->with('success', 'Merma registrada y stock actualizado correctamente.');
    }
}
