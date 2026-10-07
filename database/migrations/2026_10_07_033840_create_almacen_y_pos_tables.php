<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Tabla para Registro de Mermas y Bajas Biologicas (RF-28)
        Schema::create('mermas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('producto_id')->constrained('productos')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->integer('cantidad');
            $table->enum('motivo', ['mortalidad_biologica', 'daño_equipo', 'caducidad_insumo', 'ajuste_inventario']);
            $table->text('observaciones')->nullable();
            $table->timestamps();
        });

        // Tabla para Reportes de Corte de Caja Z (RF-24)
        Schema::create('cortes_caja', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->decimal('monto_inicial', 10, 2)->default(0.00);
            $table->decimal('ventas_efectivo', 10, 2)->default(0.00);
            $table->decimal('ventas_tarjeta', 10, 2)->default(0.00);
            $table->decimal('total_caja', 10, 2)->default(0.00);
            $table->decimal('diferencia', 10, 2)->default(0.00);
            $table->text('observaciones')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cortes_caja');
        Schema::dropIfExists('mermas');
    }
};
