import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router, useForm } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ auth, pedidos, productos }) {
    const [tab, setTab] = useState('picking');

    const { data, setData, post, processing, errors, reset } = useForm({
        producto_id: '',
        cantidad: 1,
        motivo: 'mortalidad_biologica',
        observaciones: '',
    });

    const handleMarcarListo = (id) => {
        router.post(route('almacen.listo', id));
    };

    const handleLiberarExpirados = () => {
        router.post(route('almacen.liberarExpirados'));
    };

    const handleMermaSubmit = (e) => {
        e.preventDefault();
        post(route('almacen.mermas'), {
            onSuccess: () => reset(),
        });
    };

    return (
        <AuthenticatedLayout user={auth.user}>
            <Head title="Almacen y Picking - AQUARIUM" />

            <div className="py-8 bg-slate-50 min-h-screen">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-2xl font-bold text-slate-800">Gestion de Almacen y Picking</h2>
                        <div className="flex space-x-2">
                            <button
                                onClick={() => setTab('picking')}
                                className={`px-4 py-2 rounded-lg font-medium text-sm ${tab === 'picking' ? 'bg-cyan-600 text-white' : 'bg-white text-slate-600'}`}
                            >
                                Ordenes de Picking
                            </button>
                            <button
                                onClick={() => setTab('mermas')}
                                className={`px-4 py-2 rounded-lg font-medium text-sm ${tab === 'mermas' ? 'bg-cyan-600 text-white' : 'bg-white text-slate-600'}`}
                            >
                                Registro de Mermas
                            </button>
                        </div>
                    </div>

                    {tab === 'picking' && (
                        <div className="space-y-6">
                            <div className="flex justify-between items-center bg-white p-4 rounded-xl shadow-sm">
                                <p className="text-sm text-slate-600">Monitoreo de pedidos Click & Collect para empaquetado.</p>
                                <button
                                    onClick={handleLiberarExpirados}
                                    className="bg-amber-600 hover:bg-amber-700 text-white text-xs font-semibold py-2 px-3 rounded-lg"
                                >
                                    Liberar Pedidos Expirados (>48h)
                                </button>
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                {pedidos.map((pedido) => (
                                    <div key={pedido.id} className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
                                        <div className="flex justify-between items-start mb-4">
                                            <div>
                                                <span className="text-xs font-bold text-cyan-600 bg-cyan-50 px-2 py-1 rounded">
                                                    Folio: {pedido.folio}
                                                </span>
                                                <p className="text-sm font-semibold text-slate-800 mt-1">Cliente: {pedido.user?.name}</p>
                                            </div>
                                            <span className="text-xs capitalize font-medium px-2 py-1 bg-slate-100 rounded text-slate-600">
                                                {pedido.estatus_pedido}
                                            </span>
                                        </div>

                                        <div className="border-t border-b border-slate-100 py-3 my-3 space-y-2">
                                            <p className="text-xs font-bold text-slate-500 uppercase">Lista de Picking:</p>
                                            {pedido.items?.map((item) => (
                                                <div key={item.id} className="flex justify-between text-sm">
                                                    <span>{item.producto?.nombre}</span>
                                                    <span className="font-bold text-slate-700">x{item.cantidad}</span>
                                                </div>
                                            ))}
                                        </div>

                                        {pedido.estatus_pedido !== 'listo_para_recoleccion' && (
                                            <button
                                                onClick={() => handleMarcarListo(pedido.id)}
                                                className="w-full mt-2 bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-medium py-2 rounded-lg"
                                            >
                                                Confirmar Preparado (Listo en Mostrador)
                                            </button>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    {tab === 'mermas' && (
                        <div className="bg-white p-6 rounded-xl shadow-sm max-w-2xl mx-auto">
                            <h3 className="text-lg font-bold text-slate-800 mb-4">Registrar Merma o Baja Biologica</h3>
                            <form onSubmit={handleMermaSubmit} className="space-y-4">
                                <div>
                                    <label className="block text-sm font-medium text-slate-700 mb-1">Producto / Especie</label>
                                    <select
                                        value={data.producto_id}
                                        onChange={(e) => setData('producto_id', e.target.value)}
                                        className="w-full border-slate-300 rounded-lg text-sm"
                                        required
                                    >
                                        <option value="">Selecciona un producto...</option>
                                        {productos.map((p) => (
                                            <option key={p.id} value={p.id}>
                                                {p.nombre} (Stock actual: {p.stock})
                                            </option>
                                        ))}
                                    </select>
                                </div>

                                <div className="grid grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium text-slate-700 mb-1">Cantidad a Dar de Baja</label>
                                        <input
                                            type="number"
                                            min="1"
                                            value={data.cantidad}
                                            onChange={(e) => setData('cantidad', e.target.value)}
                                            className="w-full border-slate-300 rounded-lg text-sm"
                                            required
                                        />
                                    </div>

                                    <div>
                                        <label className="block text-sm font-medium text-slate-700 mb-1">Motivo de la Merma</label>
                                        <select
                                            value={data.motivo}
                                            onChange={(e) => setData('motivo', e.target.value)}
                                            className="w-full border-slate-300 rounded-lg text-sm"
                                        >
                                            <option value="mortalidad_biologica">Mortalidad Biologica</option>
                                            <option value="daño_equipo">Dano de Equipo</option>
                                            <option value="caducidad_insumo">Caducidad de Insumo</option>
                                            <option value="ajuste_inventario">Ajuste de Inventario</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-slate-700 mb-1">Observaciones</label>
                                    <textarea
                                        value={data.observaciones}
                                        onChange={(e) => setData('observaciones', e.target.value)}
                                        className="w-full border-slate-300 rounded-lg text-sm"
                                        rows="3"
                                    ></textarea>
                                </div>

                                <button
                                    type="submit"
                                    disabled={processing}
                                    className="w-full bg-rose-600 hover:bg-rose-700 text-white font-medium py-2 rounded-lg"
                                >
                                    Registrar Baja y Descontar Stock
                                </button>
                            </form>
                        </div>
                    )}
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
