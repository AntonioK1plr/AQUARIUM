<?php
use App\Http\Controllers\AlmacenController;
use App\Http\Controllers\PosController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProductoController;
use App\Http\Controllers\CarritoController;
use App\Http\Controllers\CheckoutController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/productos', [ProductoController::class, 'index'])->name('productos.index');
});
Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/carrito', [CarritoController::class, 'index'])->name('carrito.index');
    Route::post('/carrito', [CarritoController::class, 'store'])->name('carrito.store');
    Route::patch('/carrito/{id}', [CarritoController::class, 'update'])->name('carrito.update');
    Route::delete('/carrito/{id}', [CarritoController::class, 'destroy'])->name('carrito.destroy');
    
    Route::post('/checkout', [CheckoutController::class, 'procesar'])->name('checkout.procesar');
});

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

Route::middleware(['auth', 'verified'])->group(function () {
    // Rutas de Almacen y Picking (RF-25 a RF-28)
    Route::get('/almacen', [AlmacenController::class, 'index'])->name('almacen.index');
    Route::post('/almacen/listo/{id}', [AlmacenController::class, 'marcarListo'])->name('almacen.listo');
    Route::post('/almacen/liberar-expirados', [AlmacenController::class, 'liberarExpirados'])->name('almacen.liberarExpirados');
    Route::post('/almacen/mermas', [AlmacenController::class, 'registrarMerma'])->name('almacen.mermas');

    // Rutas de Terminal POS (RF-18 a RF-24)
    Route::get('/pos', [PosController::class, 'index'])->name('pos.index');
    Route::post('/pos/buscar-producto', [PosController::class, 'buscarProducto'])->name('pos.buscarProducto');
    Route::post('/pos/buscar-qr', [PosController::class, 'buscarPorQr'])->name('pos.buscarPorQr');
    Route::post('/pos/cobrar', [PosController::class, 'procesarCobro'])->name('pos.cobrar');
    Route::post('/pos/corte-caja', [PosController::class, 'corteCaja'])->name('pos.corteCaja');
});

require __DIR__.'/auth.php';
