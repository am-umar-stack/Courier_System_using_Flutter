import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { Check, Truck, Package, MapPin, Search, ArrowLeft, ShoppingBag, ShieldCheck, Phone } from "lucide-react";
import { useSearchParams } from "react-router";
import { useAppContext, OrderItem } from "../context/AppContext";

export function Dashboard() {
  const { orders, findOrderById, updateOrderTrackingStep } = useAppContext();
  const [searchParams, setSearchParams] = useSearchParams();
  const trackParam = searchParams.get("track");

  const [activeTab, setActiveTab] = useState<"purchases" | "tracking">("purchases");
  const [selectedOrder, setSelectedOrder] = useState<string | null>(null);
  
  // Search filter for purchases list
  const [purchaseSearch, setPurchaseSearch] = useState("");
  
  // Transit Simulation State
  const [isSimulating, setIsSimulating] = useState(false);

  // Automatically select order if tracked via URL parameters
  useEffect(() => {
    if (trackParam) {
      const order = findOrderById(trackParam);
      if (order) {
        setSelectedOrder(order.id);
        setActiveTab("tracking");
      }
    }
  }, [trackParam, findOrderById]);

  // Clean URL when backing out from an order tracking view
  const handleBackToHistory = () => {
    setSelectedOrder(null);
    setActiveTab("purchases");
    setSearchParams({});
  };

  const handleTrackOrder = (orderId: string) => {
    setSelectedOrder(orderId);
    setActiveTab("tracking");
    setSearchParams({ track: orderId });
  };

  const activeOrder = selectedOrder ? findOrderById(selectedOrder) : null;

  const handleStartSimulation = () => {
    if (!activeOrder || isSimulating) return;
    setIsSimulating(true);
    let currentStep = 0;
    updateOrderTrackingStep(activeOrder.id, 0);

    const interval = setInterval(() => {
      currentStep += 1;
      if (currentStep <= 3) {
        updateOrderTrackingStep(activeOrder.id, currentStep);
      } else {
        clearInterval(interval);
        setIsSimulating(false);
      }
    }, 3000); // Progresses step every 3 seconds
  };

  const steps = [
    { id: 0, label: 'Pending', icon: Package, desc: 'Order received at hub', time: '10:23 AM' },
    { id: 1, label: 'In Transit', icon: Truck, desc: 'En route to local hub', time: '11:45 AM' },
    { id: 2, label: 'Out for Delivery', icon: MapPin, desc: 'Assigned to driver', time: '02:15 PM' },
    { id: 3, label: 'Delivered', icon: Check, desc: 'Successfully handed over', time: '03:40 PM' },
  ];

  const filteredOrders = orders.filter((order: OrderItem) => {
    const term = purchaseSearch.toLowerCase();
    return (
      order.id.toLowerCase().includes(term) ||
      order.itemsText.toLowerCase().includes(term) ||
      order.status.toLowerCase().includes(term)
    );
  });

  return (
    <div className="container mx-auto px-4 py-8 md:py-12 max-w-7xl flex-1 flex flex-col">
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold text-slate-900">AMU Logistics Dashboard</h1>
          <p className="text-slate-500 mt-1">Manage your secure shipments and track orders live.</p>
        </div>
      </div>

      {/* Tabs */}
      {!selectedOrder && (
        <div className="flex border-b border-slate-200 mb-8">
          <button 
            className={`pb-4 px-4 text-sm font-bold transition-all border-b-2 cursor-pointer ${activeTab === 'purchases' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-800'}`}
            onClick={() => setActiveTab('purchases')}
          >
            Purchases & History ({orders.length})
          </button>
          <button 
            className={`pb-4 px-4 text-sm font-bold transition-all border-b-2 cursor-pointer ${activeTab === 'tracking' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-800'}`}
            onClick={() => setActiveTab('tracking')}
            disabled={orders.length === 0}
          >
            Live Tracking
          </button>
        </div>
      )}

      {/* Main Content Area */}
      <AnimatePresence mode="wait">
        
        {/* Purchases View */}
        {activeTab === 'purchases' && !selectedOrder && (
          <motion.div 
            key="purchases"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden"
          >
            <div className="p-6 border-b border-slate-100 flex flex-col sm:flex-row gap-4 sm:items-center justify-between bg-slate-50/50">
              <h2 className="text-lg font-bold text-slate-900">Recent Orders</h2>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={16} />
                <input 
                  type="text" 
                  value={purchaseSearch}
                  onChange={(e) => setPurchaseSearch(e.target.value)}
                  placeholder="Search orders..." 
                  className="pl-9 pr-4 py-2 bg-white border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full sm:w-64" 
                />
              </div>
            </div>
            
            {filteredOrders.length === 0 ? (
              <div className="p-12 text-center">
                <ShoppingBag className="mx-auto text-slate-300 mb-3" size={36} />
                <p className="text-slate-500 text-sm font-medium">No matching orders found.</p>
              </div>
            ) : (
              <div className="divide-y divide-slate-100">
                {filteredOrders.map((order) => (
                  <div key={order.id} className="p-6 hover:bg-slate-50 transition-colors flex flex-col md:flex-row gap-6 md:items-center justify-between group">
                    <div className="flex items-start gap-4 flex-1">
                      <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 shrink-0 border border-blue-100">
                        <ShoppingBag size={20} />
                      </div>
                      <div>
                        <div className="flex items-center gap-3 mb-1">
                          <h3 className="font-bold text-slate-900">Order #{order.id}</h3>
                          <span className={`px-2.5 py-0.5 rounded-full text-xs font-bold ${
                            order.status === 'Delivered' 
                              ? 'bg-emerald-105 text-emerald-700' 
                              : order.status === 'Pending'
                              ? 'bg-blue-100 text-blue-700'
                              : 'bg-amber-100 text-amber-700'
                          }`}>
                            {order.status}
                          </span>
                        </div>
                        <p className="text-sm text-slate-500 mb-1">{order.date} • {order.storeCount} Store(s)</p>
                        <p className="text-sm text-slate-700 line-clamp-1">{order.itemsText}</p>
                      </div>
                    </div>
                    
                    <div className="flex items-center justify-between md:flex-col md:items-end gap-4 md:gap-2 shrink-0">
                      <span className="font-extrabold text-slate-900">${order.total.toFixed(2)}</span>
                      <button 
                        onClick={() => handleTrackOrder(order.id)}
                        className="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition-all shadow-sm group-hover:shadow-md active:scale-95 flex items-center gap-2 cursor-pointer"
                      >
                        <Package size={16} /> Track Order
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </motion.div>
        )}

        {/* Live Tracking View */}
        {activeTab === 'tracking' && (
          <motion.div 
            key="tracking"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="flex flex-col gap-6"
          >
            {activeOrder ? (
              <>
                <button 
                  onClick={handleBackToHistory}
                  className="inline-flex items-center text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors self-start cursor-pointer"
                >
                  <ArrowLeft size={16} className="mr-2" /> Back to Purchases
                </button>
                
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                  {/* Timeline Container */}
                  <div className="lg:col-span-2 bg-white border border-slate-200 rounded-3xl p-6 md:p-10 shadow-sm">
                    <div className="flex flex-col sm:flex-row justify-between items-start gap-4 mb-10">
                      <div>
                        <h2 className="text-2xl font-bold text-slate-900 mb-2">Live Fulfillment Status</h2>
                        <p className="text-slate-500">Tracking Number: <span className="font-bold text-slate-900">{activeOrder.id}</span></p>
                      </div>
                      <div className="text-left sm:text-right">
                        <p className="text-sm text-slate-500 uppercase tracking-wider font-bold mb-1">Est. Delivery</p>
                        <p className="text-xl font-extrabold text-blue-600">
                          {activeOrder.status === 'Delivered' 
                            ? 'Delivered Successfully' 
                            : activeOrder.shippingTier === 'instant' 
                            ? 'Today, within 2 Hours'
                            : 'Today, by 4:00 PM'}
                        </p>
                      </div>
                    </div>

                    {/* Simulation Live Data Push Notice */}
                    <div className="bg-blue-50 border border-blue-100 text-blue-800 px-4 py-4 rounded-2xl text-sm font-medium mb-10 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                      <div className="flex items-center gap-2.5">
                        <div className="w-2.5 h-2.5 bg-blue-600 rounded-full animate-pulse shrink-0"></div>
                        <span>Interactive Tracking: Click steps to trigger updates or start a transit simulation.</span>
                      </div>
                      <button 
                        onClick={handleStartSimulation}
                        disabled={isSimulating || activeOrder.status === 'Delivered'}
                        className={`px-4 py-2 rounded-xl text-xs font-bold transition-all shrink-0 cursor-pointer
                          ${isSimulating 
                            ? 'bg-blue-200 text-blue-600 cursor-not-allowed' 
                            : activeOrder.status === 'Delivered'
                            ? 'bg-slate-100 text-slate-400 cursor-not-allowed border border-slate-200'
                            : 'bg-blue-600 hover:bg-blue-700 text-white shadow-md shadow-blue-600/10'
                          }`}
                      >
                        {isSimulating ? "Simulating Journey..." : activeOrder.status === 'Delivered' ? "Journey Completed" : "Simulate Live Transit"}
                      </button>
                    </div>

                    {/* Timeline */}
                    <div className="relative pl-6 md:pl-10 pb-6">
                      {/* Background Line */}
                      <div className="absolute left-[33px] md:left-[49px] top-4 bottom-4 w-1 bg-slate-100 rounded-full"></div>
                      
                      {/* Active Fill Line */}
                      <motion.div 
                        className="absolute left-[33px] md:left-[49px] top-4 w-1 bg-blue-600 rounded-full origin-top"
                        initial={{ height: 0 }}
                        animate={{ height: `${(activeOrder.trackingStep / (steps.length - 1)) * 100}%` }}
                        transition={{ duration: 0.5, ease: "easeInOut" }}
                      ></motion.div>

                      <div className="flex flex-col gap-12 relative z-10">
                        {steps.map((step) => {
                          const Icon = step.icon;
                          const isCompleted = activeOrder.trackingStep >= step.id;
                          const isActive = activeOrder.trackingStep === step.id;
                          const isPending = activeOrder.trackingStep < step.id;

                          return (
                            <div 
                              key={step.id} 
                              className="flex items-start gap-6 cursor-pointer group"
                              onClick={() => !isSimulating && updateOrderTrackingStep(activeOrder.id, step.id)}
                            >
                              {/* Node Icon */}
                              <div className="relative">
                                <motion.div 
                                  className={`w-12 h-12 rounded-full flex items-center justify-center border-[3px] transition-all duration-300 relative z-10 bg-white
                                    ${isCompleted ? 'border-blue-600 text-blue-600' : 'border-slate-200 text-slate-400 group-hover:border-blue-300 group-hover:text-blue-400'}
                                  `}
                                  animate={isActive ? { scale: [1, 1.1, 1] } : { scale: 1 }}
                                  transition={{ duration: 0.4 }}
                                >
                                  <Icon size={20} className={isActive ? 'animate-pulse' : ''} />
                                </motion.div>
                                
                                {isActive && (
                                  <span className="absolute inset-0 rounded-full bg-blue-600/30 animate-ping z-0"></span>
                                )}
                              </div>
                              
                              {/* Node Text */}
                              <div className={`pt-1 flex-1 transition-all duration-300 ${isPending ? 'opacity-50 group-hover:opacity-80' : 'opacity-100'}`}>
                                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-1 mb-1">
                                  <h3 className={`text-lg font-bold ${isActive ? 'text-blue-700' : isCompleted ? 'text-slate-900' : 'text-slate-500'}`}>
                                    {step.label}
                                  </h3>
                                  <span className="text-sm font-bold text-slate-400">{isCompleted ? step.time : 'Pending'}</span>
                                </div>
                                <p className="text-slate-500 text-sm">{step.desc}</p>
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  </div>

                  {/* Sidebar */}
                  <div className="flex flex-col gap-6">
                    {/* Secure Delivery PIN */}
                    <div className="bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-xl text-white relative overflow-hidden">
                      <div className="absolute top-0 right-0 -mr-4 -mt-4 w-32 h-32 bg-blue-600 rounded-full opacity-20 blur-3xl"></div>
                      <h3 className="font-bold text-lg mb-6 flex items-center gap-2 relative z-10">
                        <ShieldCheck size={20} className="text-blue-400" /> Secure Delivery Code
                      </h3>
                      <div className="bg-slate-800/80 rounded-2xl p-4 text-center border border-slate-700 relative z-10 mb-4">
                        <p className="text-xs text-slate-400 uppercase tracking-widest font-bold mb-2">Provide to Driver</p>
                        <p className="text-4xl font-mono font-extrabold tracking-[0.2em] text-blue-400">{activeOrder.pin}</p>
                      </div>
                      <p className="text-sm text-slate-400 text-center relative z-10">To ensure secure handover, please provide this PIN to your AMU Courier.</p>
                    </div>

                    {/* Driver Card */}
                    <div className="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm flex items-center gap-4">
                      <div className="w-14 h-14 rounded-full overflow-hidden border-2 border-blue-500 shrink-0">
                        <img 
                          src={activeOrder.driver.avatar} 
                          alt={activeOrder.driver.name} 
                          className="w-full h-full object-cover" 
                        />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-xs font-bold text-slate-400 uppercase">Assigned Driver</p>
                        <h4 className="font-bold text-slate-900 truncate">{activeOrder.driver.name}</h4>
                        <a 
                          href={`tel:${activeOrder.driver.phone}`} 
                          className="text-xs text-blue-600 hover:text-blue-700 font-semibold mt-1 inline-flex items-center gap-1"
                        >
                          <Phone size={12} /> {activeOrder.driver.phone}
                        </a>
                      </div>
                    </div>

                    {/* Items in Shipment */}
                    <div className="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm">
                      <h3 className="font-bold text-slate-900 mb-4">Items in Shipment</h3>
                      <div className="divide-y divide-slate-100 max-h-[220px] overflow-y-auto pr-1">
                        {activeOrder.itemDetails.map((item: any, idx: number) => (
                          <div key={idx} className="py-2.5 flex gap-3 first:pt-0 last:pb-0">
                            <div className="w-10 h-10 bg-slate-100 rounded-lg overflow-hidden border border-slate-150 shrink-0">
                              <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                            </div>
                            <div className="flex-1 min-w-0">
                              <p className="text-xs font-semibold text-slate-800 truncate">{item.title}</p>
                              <p className="text-[10px] text-slate-400 font-medium">{item.store} • Qty: {item.qty}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Route Details */}
                    <div className="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm">
                       <h3 className="font-bold text-slate-900 mb-4">Delivery Route</h3>
                       <div className="space-y-4 relative">
                         <div className="absolute left-[11px] top-4 bottom-4 w-0.5 bg-slate-100"></div>
                         <div className="flex gap-4 relative z-10">
                           <div className="w-6 h-6 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center shrink-0">
                             <div className="w-2 h-2 rounded-full bg-slate-400"></div>
                           </div>
                           <div className="min-w-0">
                             <p className="text-xs font-bold text-slate-400 uppercase">Origin Stores</p>
                             <p className="text-xs font-medium text-slate-900 truncate">{activeOrder.origin}</p>
                           </div>
                         </div>
                         <div className="flex gap-4 relative z-10">
                           <div className="w-6 h-6 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center shrink-0">
                             <MapPin size={12} className="text-blue-600" />
                           </div>
                           <div className="min-w-0">
                             <p className="text-xs font-bold text-slate-400 uppercase">Destination</p>
                             <p className="text-xs font-medium text-slate-900 line-clamp-2">{activeOrder.destination}</p>
                           </div>
                         </div>
                       </div>
                    </div>
                  </div>
                </div>
              </>
            ) : (
              <div className="bg-white border border-slate-200 rounded-3xl p-12 text-center">
                <Search size={48} className="mx-auto text-slate-300 mb-4 animate-bounce" />
                <h2 className="text-2xl font-bold text-slate-900 mb-2">Tracking Shipment Not Found</h2>
                <p className="text-slate-500 max-w-md mx-auto mb-6 text-sm">We couldn't find an order with the tracking number "{trackParam}". Please verify the code or check your recent order history below.</p>
                <button 
                  onClick={handleBackToHistory}
                  className="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2.5 px-6 rounded-xl text-sm transition-all"
                >
                  View Order History
                </button>
              </div>
            )}
          </motion.div>
        )}

      </AnimatePresence>
    </div>
  );
}
