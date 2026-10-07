<?php

namespace App\Http\Controllers;

use App\Models\CarritoItem;
use App\Models\Producto;
use App\Services\CompatibilidadBiologicaService;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CarritoController extends Controller
{
        protected $compatibilidadService;

    public function __construct(CompatibilidadBiologicaService $compatibilidadService)
    {
        $this->compatibilidadService = $compatibilidadService;
    }

    public function index(Request $request)
    {
        $items = CarritoItem::with('producto')
            ->where('user_id', $request->user()->id)
            ->get();

        $productos = $items->pluck('producto');
        $evaluacion = $this->compatibilidadService->evaluarCompatibilidad($productos);

        $subtotal = $items->sum(function ($item) {
            return $item->producto->precio * $item->cantidad;
        });

        $iva = $subtotal * 0.16;
        $total = $subtotal + $iva;

        return Inertia::render('Carrito/Index', [
            'items' => $items,
            'evaluacion' => $evaluacion,
            'resumen' => [
                'subtotal' => round($subtotal, 2),
                'iva' => round($iva, 2),
                'total' => round($total, 2),
            ]
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'producto_id' => 'required|exists:productos,id',
            'cantidad' => 'required|integer|min:1',
        ]);

        $producto = Producto::findOrFail($request->producto_id);

        if ($producto->stock < $request->cantidad) {
            return back()->withErrors(['stock' => 'No hay suficiente inventario disponible.']);
        }

        $item = CarritoItem::firstOrNew([
            'user_id' => $request->user()->id,
            'producto_id' => $request->producto_id,
        ]);

        $item->cantidad = $item->exists ? ($item->cantidad + $request->cantidad) : $request->cantidad;
        $item->reservado_hasta = now()->addMinutes(30); // BR-005
        $item->save();

        return redirect()->route('carrito.index')->with('success', 'Producto añadido al carrito.');
    }

    public function update(Request $request, $id)
    {
        $request->validate(['cantidad' => 'required|integer|min:1']);

        $item = CarritoItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->cantidad = $request->cantidad;
        $item->save();

        return back();
    }

    public function destroy(Request $request, $id)
    {
        $item = CarritoItem::where('user_id', $request->user()->id)->findOrFail($id);
        $item->delete();

        return back();
    }

}
