<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Seeder;
class RoleSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('roles')->insert([
            ['id' => 1, 'nombre' => 'Administrador', 'descripcion' => 'Acceso total y alta de personal (BR-002)'],
            ['id' => 2, 'nombre' => 'Cajero',       'descripcion' => 'Acceso a Terminal POS y cobros en mostrador'],
            ['id' => 3, 'nombre' => 'Almacenista',   'descripcion' => 'Gestión de picking, mermas e inventario'],
            ['id' => 4, 'nombre' => 'Veterinario',   'descripcion' => 'Atención médica, expediente clínico y recetas'],
            ['id' => 5, 'nombre' => 'Cliente',       'descripcion' => 'E-Commerce, citas y pedidos Click & Collect'],
        ]);
    }
}

