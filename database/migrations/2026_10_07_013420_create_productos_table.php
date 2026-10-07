<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
{
    Schema::create('productos', function (Blueprint $table) {
        $table->id();
        $table->string('nombre');
        $table->enum('tipo', ['fauna', 'flora', 'equipo', 'insumo']);
        $table->decimal('precio', 8, 2);
        $table->integer('stock')->default(0);
        $table->string('imagen_url')->nullable();

        // Parámetros de Compatibilidad Biológica (RF-09 / BR-014)
        $table->float('ph_min')->nullable();
        $table->float('ph_max')->nullable();
        $table->float('temp_min')->nullable();
        $table->float('temp_max')->nullable();
        $table->enum('nivel_agresividad', ['pacifico', 'semi_agresivo', 'agresivo'])->nullable();
        $table->enum('tipo_agua', ['dulce', 'salada', 'ambos'])->default('dulce');

        $table->boolean('estatus')->default(true);
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('productos');
    }
};
