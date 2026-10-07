import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ auth, items, evaluacion, resumen }) {
    const [metodoEntrega, setMetodoEntrega] = useState('click_collect');
    const [aceptaCarta, setAceptaCarta] = useState(false);
    const [mostrarModalCarta, setMostrarModalCarta] = useState(false);

    const handleActualizarCantidad = (id, cantidad) => {
        if (cantidad < 1) return;
        router.patch(route('carrito.update', id), { cantidad });
    };

    const handleEliminar = (id) => {
        router.delete(route('carrito.destroy', id));
    };

    const handleProcesarPedido = (e) => {
        e.preventDefault();
        
        if (evaluacion.requiere_carta_responsiva && !aceptaCarta) {
            setMostrarModalCarta(true);
            return;
        }

        router.post(route('checkout.procesar'), {
            metodo_entrega: metodoEntrega,
            acepta_carta_responsiva: aceptaCarta,
        });
    };

    const handleConfirmarCartaModal = () => {
        setAceptaCarta(true);
        setMostrarModalCarta(false);
        
        router.post(route('checkout.procesar'), {
            metodo_entrega: metodoEntrega,
            acepta_carta_responsiva: true,
        });
    };

    return (
        <AuthenticatedLayout user={auth.user}>
            <Head title="Carrito de Compras - AQUARIUM" />

            <div className="py-12 bg-slate-50 min-h-screen">
                <div className="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <h2 className="text-3xl font-bold text-slate-800 mb-8">Carrito de Compras</h2>

                    {/* Alerta de Compatibilidad Biológica (RF-11 / BR-014) */}
                    {!evaluacion.es_compatible && (
                        <div className="bg-amber-50 border-l-4 border-amber-500 p-5 rounded-r-xl shadow-sm mb-8">
                            <h3 className="text-lg font-bold text-amber-800 mb-2">
                                Advertencia de Compatibilidad Biologica Detectada
                            </h3>
                            <ul className="list-disc list-inside text-sm text-amber-700 space-y-1">
                                {evaluacion.advertencias.map((adv, idx) => (
                                    <li key={idx}>{adv}</li>
                                ))}
                            </ul>
                            <p className="text-xs text-amber-600 mt-3 font-semibold">
                                Nota: Para proceder con la compra requerira la firma digital de la Carta Responsiva Biologica.
                            </p>
                        </div>
                    )}

                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        {/* Lista de Productos en el Carrito */}
                        <div className="lg:col-span-2 space-y-4">
                            {items.length === 0 ? (
                                <div className="bg-white p-8 rounded-xl shadow-sm border border-slate-100 text-center">
                                    <p className="text-slate-500">Tu carrito esta actualmente vacio.</p>
                                </div>
                            ) : (
                                items.map((item) => (
                                    <div key={item.id} className="bg-white p-5 rounded-xl shadow-sm border border-slate-100 flex flex-col sm:flex-row justify-between items-center gap-4">
                                        <div className="flex items-center gap-4 w-full sm:w-auto">
                                            {item.producto.imagen_url && (
                                                <img src={item.producto.imagen_url} alt={item.producto.nombre} className="w-20 h-20 object-cover rounded-lg" />
                                            )}
                                            <div>
                                                <h4 className="font-bold text-slate-800">{item.producto.nombre}</h4>
                                                <p className="text-sm text-cyan-600 font-semibold">${Number(item.producto.precio).toFixed(2)} MXN</p>
                                                <span className="text-xs text-slate-400 capitalize">Tipo: {item.producto.tipo}</span>
                                            </div>
                                        </div>

                                        <div className="flex items-center gap-3">
                                            <button 
                                                onClick={() => handleActualizarCantidad(item.id, item.cantidad - 1)}
                                                className="px-3 py-1 bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200"
                                            >-</button>
                                            <span className="font-bold text-slate-800 w-8 text-center">{item.cantidad}</span>
                                            <button 
                                                onClick={() => handleActualizarCantidad(item.id, item.cantidad + 1)}
                                                className="px-3 py-1 bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200"
                                            >+</button>
                                            <button 
                                                onClick={() => handleEliminar(item.id)}
                                                className="ml-4 text-rose-600 hover:text-rose-800 text-sm font-semibold"
                                            >Eliminar</button>
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>

                        {/* Resumen de Pago y Checkout */}
                        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100 h-fit space-y-6">
                            <h3 className="text-xl font-bold text-slate-800 border-b pb-3">Resumen de Pedido</h3>

                            <div className="space-y-2 text-sm text-slate-600">
                                <div className="flex justify-between">
                                    <span>Subtotal:</span>
                                    <span>${resumen.subtotal.toFixed(2)} MXN</span>
                                </div>
                                <div className="flex justify-between">
                                    <span>IVA (16%):</span>
                                    <span>${resumen.iva.toFixed(2)} MXN</span>
                                </div>
                                <div className="flex justify-between font-bold text-lg text-slate-900 border-t pt-3">
                                    <span>Total:</span>
                                    <span className="text-cyan-600">${resumen.total.toFixed(2)} MXN</span>
                                </div>
                            </div>

                            {/* Seleccion de Metodo de Entrega */}
                            <div className="space-y-2">
                                <label className="block text-sm font-semibold text-slate-700">Metodo de Entrega:</label>
                                <select 
                                    value={metodoEntrega}
                                    onChange={(e) => setMetodoEntrega(e.target.value)}
                                    className="w-full border-slate-300 rounded-lg text-sm"
                                >
                                    <option value="click_collect">Click & Collect (Recoger en Tienda)</option>
                                    <option value="envio_domicilio">Envio a Domicilio</option>
                                </select>
                            </div>

                            <button
                                onClick={handleProcesarPedido}
                                disabled={items.length === 0}
                                className="w-full bg-cyan-600 hover:bg-cyan-700 disabled:bg-slate-300 text-white font-bold py-3 rounded-lg shadow transition"
                            >
                                Confirmar y Pagar
                            </button>
                        </div>
                    </div>

                    {/* Modal de Firma de Carta Responsiva Digital (RF-12) */}
                    {mostrarModalCarta && (
                        <div className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
                            <div className="bg-white max-w-xl w-full p-6 rounded-2xl shadow-xl space-y-4">
                                <h3 className="text-xl font-bold text-slate-800 border-b pb-2">
                                    Carta Responsiva de Compatibilidad Biologica
                                </h3>
                                <p className="text-sm text-slate-600">
                                    El sistema ha detectado incompatibilidades de especies, pH o temperatura en su seleccion. Al continuar, usted declara conocer los riesgos biologicos para las especies involucradas y exime a AQUARIUM de responsabilidad por incompatibilidad en su acuario.
                                </p>
                                <div className="flex items-center gap-2 border p-3 rounded-lg bg-slate-50">
                                    <input 
                                        type="checkbox" 
                                        id="chkCarta"
                                        checked={aceptaCarta}
                                        onChange={(e) => setAceptaCarta(e.target.checked)}
                                        className="rounded text-cyan-600"
                                    />
                                    <label htmlFor="chkCarta" className="text-sm font-semibold text-slate-700">
                                        Acepto y firmo digitalmente esta carta responsiva.
                                    </label>
                                </div>
                                <div className="flex justify-end gap-3 pt-4">
                                    <button 
                                        onClick={() => setMostrarModalCarta(false)}
                                        className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg text-sm"
                                    >Cancelar</button>
                                    <button 
                                        onClick={handleConfirmarCartaModal}
                                        disabled={!aceptaCarta}
                                        className="px-4 py-2 bg-cyan-600 disabled:bg-slate-300 text-white font-bold rounded-lg text-sm"
                                    >Aceptar y Continuar</button>
                                </div>
                            </div>
                        </div>
                    )}

                </div>
            </div>
        </AuthenticatedLayout>
    );
}
