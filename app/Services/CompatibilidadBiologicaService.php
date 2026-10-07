<?php

namespace App\Services;

use App\Models\Producto;
use Illuminate\Support\Collection;

class CompatibilidadBiologicaService
{
    public function evaluarCompatibilidad(Collection $productos): array
    {
        $fauna = $productos->where('tipo', 'fauna');
        
        if ($fauna->count() <= 1) {
            return [
                'es_compatible' => true,
                'advertencias' => [],
                'requiere_carta_responsiva' => false,
            ];
        }

        $advertencias = [];
        $requiereCarta = false;

        // 1. Validacion de Tipo de Agua
        $tiposAgua = $fauna->pluck('tipo_agua')->unique();
        if ($tiposAgua->contains('dulce') && $tiposAgua->contains('salada')) {
            $advertencias[] = "Incompatibilidad Critica: No se pueden mezclar especies de agua dulce con especies de agua salada.";
            $requiereCarta = true;
        }

        // 2. Validacion de rangos de pH
        $phMinMax = $fauna->max('ph_min');
        $phMaxMin = $fauna->min('ph_max');
        if ($phMinMax !== null && $phMaxMin !== null && $phMinMax > $phMaxMin) {
            $advertencias[] = "Incompatibilidad de pH: Los rangos de pH tolerados por las especies seleccionadas no se solapan de manera segura.";
            $requiereCarta = true;
        }

        // 3. Validacion de rangos de Temperatura
        $tempMinMax = $fauna->max('temp_min');
        $tempMaxMin = $fauna->min('temp_max');
        if ($tempMinMax !== null && $tempMaxMin !== null && $tempMinMax > $tempMaxMin) {
            $advertencias[] = "Incompatibilidad de Temperatura: Los rangos de temperatura de supervivencia no son coincidentes.";
            $requiereCarta = true;
        }

        // 4. Validacion de Agresividad y Temperamento
        $niveles = $fauna->pluck('nivel_agresividad');
        if ($niveles->contains('agresivo') && $niveles->contains('pacifico')) {
            $advertencias[] = "Riesgo de Depredacion: Hay especies agresivas conviviendo con especies pacificas en el mismo carrito.";
            $requiereCarta = true;
        }

        return [
            'es_compatible' => count($advertencias) === 0,
            'advertencias' => $advertencias,
            'requiere_carta_responsiva' => $requiereCarta,
        ];
    }
}
