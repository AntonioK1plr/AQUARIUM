<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Tabla de Carrito de Compras
        Schema::create('carrito_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('producto_id')->constrained()->onDelete('cascade');
            $table->integer('cantidad')->default(1);
            $table->timestamps();
        });

        // Tabla de Pedidos / Ordenes
        Schema::create('pedidos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->string('folio')->unique();
            $table->decimal('total', 10, 2);
            $table->enum('metodo_entrega', ['envio_domicilio', 'click_collect'])->default('click_collect');
            $table->enum('estado', ['pendiente_pago', 'pagado', 'en_picking', 'listo_mostrador', 'entregado', 'cancelado'])->default('pendiente_pago');
            $table->boolean('carta_responsiva_firmada')->default(false);
            $table->string('codigo_qr')->nullable();
            $table->timestamp('apartado_expira_at')->nullable(); // BR-005: 30 minutos
            $table->timestamps();
        });

        // Detalle de Pedido
        Schema::create('pedido_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pedido_id')->constrained()->onDelete('cascade');
            $table->foreignId('producto_id')->constrained();
            $table->integer('cantidad');
            $table->decimal('precio_unitario', 8, 2);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pedido_items');
        Schema::dropIfExists('pedidos');
        Schema::dropIfExists('carrito_items');
    }
};
