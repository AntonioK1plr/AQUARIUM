<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ProductoController extends Controller
{
    public function index(Request $request)
    {
        $query = Producto::where('estatus', true);

        // Búsqueda indexada por nombre (RF-07)
        if ($request->filled('buscar')) {
            $query->where('nombre', 'ilike', '%' . $request->buscar . '%');
        }

        // Filtro por tipo: fauna, flora, equipo, insumo (RF-08)
        if ($request->filled('tipo') && $request->tipo !== 'todos') {
            $query->where('tipo', $request->tipo);
        }

        // Filtro por tipo de agua: dulce, salada (RF-08)
        if ($request->filled('tipo_agua') && $request->tipo_agua !== 'todos') {
            $query->where('tipo_agua', $request->tipo_agua);
        }

        $productos = $query->latest()->get();

        return Inertia::render('Productos/Index', [
            'productos' => $productos,
            'filters' => $request->only(['buscar', 'tipo', 'tipo_agua']),
        ]);
    }
}
