<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Producto;

class ProductoSeeder extends Seeder
{
    public function run(): void
    {
        Producto::create([
            'nombre' => 'Pez Neón Tetras (Paracheirodon innesi)',
            'tipo' => 'fauna',
            'precio' => 45.00,
            'stock' => 50,
            'imagen_url' => 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=500',
            'ph_min' => 6.0,
            'ph_max' => 7.0,
            'temp_min' => 20.0,
            'temp_max' => 26.0,
            'nivel_agresividad' => 'pacifico',
            'tipo_agua' => 'dulce',
        ]);

        Producto::create([
            'nombre' => 'Pez Disco Turquesa (Symphysodon)',
            'tipo' => 'fauna',
            'precio' => 850.00,
            'stock' => 12,
            'imagen_url' => 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?w=500',
            'ph_min' => 6.0,
            'ph_max' => 6.8,
            'temp_min' => 28.0,
            'temp_max' => 31.0,
            'nivel_agresividad' => 'pacifico',
            'tipo_agua' => 'dulce',
        ]);

        Producto::create([
            'nombre' => 'Pez Betta Splendens Macho',
            'tipo' => 'fauna',
            'precio' => 120.00,
            'stock' => 20,
            'imagen_url' => 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
            'ph_min' => 6.5,
            'ph_max' => 7.5,
            'temp_min' => 24.0,
            'temp_max' => 30.0,
            'nivel_agresividad' => 'agresivo',
            'tipo_agua' => 'dulce',
        ]);

        Producto::create([
            'nombre' => 'Pez Cirujano Azul (Paracanthurus hepatus)',
            'tipo' => 'fauna',
            'precio' => 1400.00,
            'stock' => 8,
            'imagen_url' => 'https://images.unsplash.com/photo-1548407260-da850faa41e3?w=500',
            'ph_min' => 8.1,
            'ph_max' => 8.4,
            'temp_min' => 24.0,
            'temp_max' => 27.0,
            'nivel_agresividad' => 'semi_agresivo',
            'tipo_agua' => 'salada',
        ]);

        Producto::create([
            'nombre' => 'Planta Anubia Nana sobre Tronco',
            'tipo' => 'flora',
            'precio' => 190.00,
            'stock' => 15,
            'imagen_url' => 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=500',
            'ph_min' => 6.0,
            'ph_max' => 8.0,
            'temp_min' => 22.0,
            'temp_max' => 28.0,
            'nivel_agresividad' => null,
            'tipo_agua' => 'dulce',
        ]);

        Producto::create([
            'nombre' => 'Filtro Cascada Silencioso 500L/h',
            'tipo' => 'equipo',
            'precio' => 650.00,
            'stock' => 30,
            'imagen_url' => 'https://images.unsplash.com/photo-1584267385494-9fdd9a71ad75?w=500',
            'tipo_agua' => 'ambos',
        ]);
    }
}
