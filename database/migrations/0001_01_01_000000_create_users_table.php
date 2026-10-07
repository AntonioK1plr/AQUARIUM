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
    // 1. Tabla de Roles del Sistema
    Schema::create('roles', function (Blueprint $table) {
        $table->id();
        $table->string('nombre')->unique(); // 'Administrador', 'Cajero', 'Almacenista', 'Veterinario', 'Cliente'
        $table->string('descripcion')->nullable();
        $table->timestamps();
    });

    // 2. Tabla de Usuarios Modificada para AQUARIUM
    Schema::create('users', function (Blueprint $table) {
        $table->id();
        $table->foreignId('role_id')->default(5)->constrained('roles'); // 5 = Cliente por defecto (BR-001)
        $table->string('name');
        $table->string('email')->unique();
        $table->timestamp('email_verified_at')->nullable();
        $table->string('password');
        $table->string('telefono', 15)->nullable(); // RF-05 / RF-07
        $table->text('direccion')->nullable();       // RF-05 / RF-07
        $table->boolean('estatus')->default(true);
        $table->rememberToken();
        $table->timestamps();
    });

    Schema::create('password_reset_tokens', function (Blueprint $table) {
        $table->string('email')->primary();
        $table->string('token');
        $table->timestamp('created_at')->nullable();
    });

    Schema::create('sessions', function (Blueprint $table) {
        $table->string('id')->primary();
        $table->foreignId('user_id')->nullable()->index();
        $table->string('ip_address', 45)->nullable();
        $table->text('user_agent')->nullable();
        $table->longText('payload');
        $table->integer('last_activity')->index();
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
