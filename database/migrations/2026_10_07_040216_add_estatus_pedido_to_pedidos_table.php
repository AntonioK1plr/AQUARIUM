<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('pedidos', function (Blueprint $table) {
            if (!Schema::hasColumn('pedidos', 'estatus_pedido')) {
                $table->enum('estatus_pedido', ['pendiente', 'en_picking', 'listo_para_recoleccion', 'completado', 'cancelado'])->default('pendiente');
            }
        });
    }

    public function down(): void
    {
        Schema::table('pedidos', function (Blueprint $table) {
            $table->dropColumn('estatus_pedido');
        });
    }
};

