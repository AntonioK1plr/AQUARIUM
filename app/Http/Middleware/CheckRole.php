<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        if (! $request->user() || ! in_array($request->user()->role->nombre, $roles)) {
            // Si no tiene el rol permitido, cancela con acceso prohibido (403)
            abort(403, 'Acceso no autorizado para tu perfil de usuario.');
        }

        return $next($request);
    }
}

