<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CorteCaja extends Model
{
    use HasFactory;

    protected $table = 'cortes_caja';

    protected $fillable = [
        'user_id',
        'monto_inicial',
        'ventas_efectivo',
        'ventas_tarjeta',
        'total_caja',
        'diferencia',
        'observaciones',
    ];

    protected $casts = [
        'monto_inicial' => 'decimal:2',
        'ventas_efectivo' => 'decimal:2',
        'ventas_tarjeta' => 'decimal:2',
        'total_caja' => 'decimal:2',
        'diferencia' => 'decimal:2',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
