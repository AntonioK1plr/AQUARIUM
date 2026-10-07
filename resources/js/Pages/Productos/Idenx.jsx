import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ auth, productos, filters }) {
    const [buscar, setBuscar] = useState(filters.buscar || '');
    const [tipo, setTipo] = useState(filters.tipo || 'todos');
    const [tipoAgua, setTipoAgua] = useState(filters.tipo_agua || 'todos');

    const handleFiltrar = (e) => {
        e.preventDefault();
        router.get(route('productos.index'), { buscar, tipo, tipo_agua: tipoAgua }, { preserveState: true });
    };

    return (
        <AuthenticatedLayout user={auth.user}>
            <Head title="Catálogo de Productos - AQUARIUM" />

            <div className="py-12 bg-gray-50 min-h-screen">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    
                    {/* Encabezado y Filtros */}
                    <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 mb-8">
                        <h2 className="text-2xl font-bold text-gray-800 mb-4">Catálogo de Especies y Productos</h2>
                        
                        <form onSubmit={handleFiltrar} className="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <input
                                type="text"
                                placeholder="Buscar por nombre..."
                                value={buscar}
                                onChange={(e) => setBuscar(e.target.value)}
                                className="border-gray-300 focus:border-cyan-500 focus:ring-cyan-500 rounded-lg shadow-sm"
                            />

                            <select
                                value={tipo}
                                onChange={(e) => setTipo(e.target.value)}
                                className="border-gray-300 focus:border-cyan-500 focus:ring-cyan-500 rounded-lg shadow-sm"
                            >
                                <option value="todos">Todos los Tipos</option>
                                <option value="fauna">Fauna (Peces)</option>
                                <option value="flora">Flora (Plantas)</option>
                                <option value="equipo">Equipos</option>
                                <option value="insumo">Insumos</option>
                            </select>

                            <select
                                value={tipoAgua}
                                onChange={(e) => setTipoAgua(e.target.value)}
                                className="border-gray-300 focus:border-cyan-500 focus:ring-cyan-500 rounded-lg shadow-sm"
                            >
                                <option value="todos">Cualquier Agua</option>
                                <option value="dulce">Agua Dulce </option>
                                <option value="salada">Agua Salada </option>
                            </select>

                            <button
                                type="submit"
                                className="bg-cyan-600 hover:bg-cyan-700 text-white font-medium py-2 px-4 rounded-lg shadow transition"
                            >
                                Filtrar
                            </button>
                        </form>
                    </div>

                    {/* Grilla de Tarjetas */}
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                        {productos.map((item) => (
                            <div key={item.id} className="bg-white rounded-xl shadow-sm hover:shadow-md transition border border-gray-100 overflow-hidden flex flex-col">
                                {item.imagen_url && (
                                    <img src={item.imagen_url} alt={item.nombre} className="h-48 w-full object-cover" />
                                )}
                                <div className="p-5 flex-1 flex flex-col justify-between">
                                    <div>
                                        <div className="flex justify-between items-start mb-2">
                                            <span className="text-xs uppercase tracking-wider font-semibold px-2 py-1 bg-cyan-50 text-cyan-700 rounded-full">
                                                {item.tipo}
                                            </span>
                                            <span className="text-xs font-semibold px-2 py-1 bg-gray-100 text-gray-600 rounded-full">
                                                Agua: {item.tipo_agua}
                                            </span>
                                        </div>
                                        <h3 className="text-lg font-bold text-gray-900 mb-1">{item.nombre}</h3>
                                        <p className="text-2xl font-extrabold text-cyan-600 mb-3">${Number(item.precio).toFixed(2)} MXN</p>
                                    </div>

                                    {item.tipo === 'fauna' && (
                                        <div className="bg-slate-50 p-3 rounded-lg text-xs space-y-1 my-3 border border-slate-100">
                                            <p className="font-semibold text-slate-700">Parámetros de Hábitat:</p>
                                            <div className="flex justify-between text-slate-600">
                                                <span> pH: {item.ph_min} - {item.ph_max}</span>
                                                <span>Temp: {item.temp_min}°C - {item.temp_max}°C</span>
                                            </div>
                                            <p className="text-slate-600 capitalize">
                                                 Temperamento: <span className="font-bold">{item.nivel_agresividad}</span>
                                            </p>
                                        </div>
                                    )}

                                    <button className="w-full mt-2 bg-slate-900 hover:bg-cyan-600 text-white text-sm font-medium py-2 rounded-lg transition">
                                        Añadir al Carrito 
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>

                </div>
            </div>
        </AuthenticatedLayout>
    );
}
