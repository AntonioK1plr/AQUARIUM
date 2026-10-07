<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    use HasFactory;

    protected $fillable = [
        'nombre',
        'tipo',
        'precio',
        'stock',
        'imagen_url',
        'ph_min',
        'ph_max',
        'temp_min',
        'temp_max',
        'nivel_agresividad',
        'tipo_agua',
        'estatus',
    ];

    protected $casts = [
        'precio' => 'decimal:2',
        'stock' => 'integer',
        'ph_min' => 'float',
        'ph_max' => 'float',
        'temp_min' => 'float',
        'temp_max' => 'float',
        'estatus' => 'boolean',
    ];
}