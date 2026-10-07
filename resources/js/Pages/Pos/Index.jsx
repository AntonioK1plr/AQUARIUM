import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, useForm, usePage } from '@inertiajs/react';
import { useState } from 'react';

export default function Index({ auth, productos }) {
    const { flash } = usePage().props;
    const [cart, setCart] = useState([]);
    const [metodoPago, setMetodoPago] = useState('efectivo');
    const [montoRecibido, setMontoRecibido] = useState('');
    const [montoInicialCorte, setMontoInicialCorte] = useState('500');

    const addToCart = (producto) => {
        const exists = cart.find((i) => i.producto_id === producto.id);
        if (exists) {
            setCart(cart.map((i) => (i.producto_id === producto.id ? { ...i, cantidad: i.cantidad + 1 } : i)));
        } else {
            setCart([...cart, { producto_id: producto.id, nombre: producto.nombre, precio: producto.precio, cantidad: 1 }]);
        }
    };

    const removeFromCart = (id) => {
        setCart(cart.filter((i) => i.producto_id !== id));
    };

    const subtotal = cart.reduce((acc, item) => acc + item.precio * item.cantidad, 0);
    const iva = subtotal * 0.16;
    const total = subtotal + iva;

    const { post, processing } = useForm();

    const handleCobrar = (e) => {
        e.preventDefault();
        post(route('pos.cobrar'), {
            data: {
                items: cart,
                metodo_pago: metodoPago,
                monto_recibido: montoRecibido,
            },
            onSuccess: () => {
                setCart([]);
                setMontoRecibido('');
            },
        });
    };

    const handleCorteZ = () => {
        post(route('pos.corteCaja'), {
            data: { monto_inicial: montoInicialCorte, observaciones: 'Corte Z de fin de turno' },
        });
    };

    return (
        <AuthenticatedLayout user={auth.user}>
            <Head title="Terminal POS - AQUARIUM" />

            <div className="py-6 bg-slate-900 min-h-screen text-slate-100">
                <div className="max-w-7xl mx-auto px-4 grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Lista de Productos / Catalogo POS */}
                    <div className="lg:col-span-2 space-y-4">
                        <div className="flex justify-between items-center bg-slate-800 p-4 rounded-xl border border-slate-700">
                            <h2 className="text-xl font-bold">Punto de Venta Mostrador</h2>
                            <button
                                onClick={handleCorteZ}
                                className="bg-amber-600 hover:bg-amber-700 text-white text-xs font-bold py-2 px-3 rounded-lg"
                            >
                                Generar Corte Z
                            </button>
                        </div>

                        <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
                            {productos.map((prod) => (
                                <button
                                    key={prod.id}
                                    onClick={() => addToCart(prod)}
                                    className="bg-slate-800 hover:bg-slate-700 p-4 rounded-xl border border-slate-700 text-left flex flex-col justify-between h-32"
                                >
                                    <span className="font-bold text-sm text-slate-200 line-clamp-2">{prod.nombre}</span>
                                    <div>
                                        <p className="text-xs text-slate-400">Stock: {prod.stock}</p>
                                        <p className="text-lg font-black text-cyan-400">${Number(prod.precio).toFixed(2)}</p>
                                    </div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Carrito POS y Procesamiento de Cobro */}
                    <div className="bg-slate-800 p-6 rounded-xl border border-slate-700 flex flex-col justify-between">
                        <div>
                            <h3 className="text-lg font-bold border-b border-slate-700 pb-3 mb-4">Orden Actual</h3>

                            <div className="space-y-3 max-h-60 overflow-y-auto pr-1">
                                {cart.map((item) => (
                                    <div key={item.producto_id} className="flex justify-between items-center bg-slate-900 p-3 rounded-lg text-sm">
                                        <div>
                                            <p className="font-semibold">{item.nombre}</p>
                                            <p className="text-xs text-slate-400">x{item.cantidad} - ${item.precio} c/u</p>
                                        </div>
                                        <div className="flex items-center space-x-3">
                                            <span className="font-bold text-cyan-400">${(item.precio * item.cantidad).toFixed(2)}</span>
                                            <button
                                                onClick={() => removeFromCart(item.producto_id)}
                                                className="text-rose-400 hover:text-rose-300 text-xs font-bold"
                                            >
                                                X
                                            </button>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="border-t border-slate-700 pt-4 mt-6 space-y-3">
                            <div className="text-sm space-y-1 text-slate-400">
                                <div className="flex justify-between"><span>Subtotal:</span><span>${subtotal.toFixed(2)}</span></div>
                                <div className="flex justify-between"><span>IVA (16%):</span><span>${iva.toFixed(2)}</span></div>
                                <div className="flex justify-between text-lg font-black text-white pt-2 border-t border-slate-700">
                                    <span>Total:</span><span className="text-cyan-400">${total.toFixed(2)}</span>
                                </div>
                            </div>

                            <form onSubmit={handleCobrar} className="space-y-3 pt-2">
                                <div className="grid grid-cols-2 gap-2">
                                    <button
                                        type="button"
                                        onClick={() => setMetodoPago('efectivo')}
                                        className={`py-2 text-xs font-bold rounded-lg border ${metodoPago === 'efectivo' ? 'bg-cyan-600 border-cyan-500 text-white' : 'bg-slate-900 border-slate-700 text-slate-400'}`}
                                    >
                                        Efectivo
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setMetodoPago('tarjeta')}
                                        className={`py-2 text-xs font-bold rounded-lg border ${metodoPago === 'tarjeta' ? 'bg-cyan-600 border-cyan-500 text-white' : 'bg-slate-900 border-slate-700 text-slate-400'}`}
                                    >
                                        Tarjeta
                                    </button>
                                </div>

                                {metodoPago === 'efectivo' && (
                                    <div>
                                        <label className="block text-xs font-medium text-slate-400 mb-1">Monto Recibido ($)</label>
                                        <input
                                            type="number"
                                            step="0.01"
                                            value={montoRecibido}
                                            onChange={(e) => setMontoRecibido(e.target.value)}
                                            className="w-full bg-slate-900 border-slate-700 rounded-lg text-sm text-white"
                                            required
                                        />
                                    </div>
                                )}

                                <button
                                    type="submit"
                                    disabled={cart.length === 0 || processing}
                                    className="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3 rounded-lg transition"
                                >
                                    Procesar Cobro e Imprimir Ticket
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
