import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { Check, Truck, Package, MapPin, Clock, Search, ArrowLeft, ShoppingBag, ShieldCheck } from "lucide-react";

export function Dashboard() {
  const [activeTab, setActiveTab] = useState<"purchases" | "tracking">("purchases");
  const [selectedOrder, setSelectedOrder] = useState<string | null>(null);
  
  // Interactive progress state for simulation
  const [trackingStep, setTrackingStep] = useState<number>(1); // 0: Pending, 1: In Transit, 2: Out, 3: Delivered

  const pastOrders = [
    { id: 'PK-10582', date: 'Today, 10:23 AM', status: 'In Transit', total: 464.00, storeCount: 2, items: 'Noise-Canceling Headphones, Sneakers' },
    { id: 'PK-09214', date: 'Oct 12, 2023', status: 'Delivered', total: 120.00, storeCount: 1, items: 'Urban Minimalist Jacket' },
    { id: 'PK-08831', date: 'Oct 05, 2023', status: 'Delivered', total: 45.50, storeCount: 1, items: 'Organic Fresh Produce Box' },
  ];

  const handleTrackOrder = (orderId: string) => {
    setSelectedOrder(orderId);
    setTrackingStep(1); // Reset simulation for this demo
    setActiveTab("tracking");
  };

  const steps = [
    { id: 0, label: 'Pending', icon: Package, desc: 'Order received', time: '10:23 AM' },
    { id: 1, label: 'In Transit', icon: Truck, desc: 'En route to local hub', time: '11:45 AM' },
    { id: 2, label: 'Out for Delivery', icon: MapPin, desc: 'Assigned to driver', time: '--:--' },
    { id: 3, label: 'Delivered', icon: Check, desc: 'Successfully delivered', time: '--:--' },
  ];

  return (
    <div className="container mx-auto px-4 py-8 md:py-12 max-w-7xl flex-1 flex flex-col">
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold text-slate-900">My Logistics</h1>
          <p className="text-slate-500 mt-1">Manage your multi-store orders and live shipments.</p>
        </div>
      </div>

      {/* Tabs */}
      {!selectedOrder && (
        <div className="flex border-b border-slate-200 mb-8">
          <button 
            className={`pb-4 px-4 text-sm font-bold transition-all border-b-2 ${activeTab === 'purchases' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-800'}`}
            onClick={() => setActiveTab('purchases')}
          >
            Purchases & History
          </button>
          <button 
            className={`pb-4 px-4 text-sm font-bold transition-all border-b-2 ${activeTab === 'tracking' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-800'}`}
            onClick={() => setActiveTab('tracking')}
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
            <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
              <h2 className="text-lg font-bold text-slate-900">Recent Orders</h2>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={16} />
                <input type="text" placeholder="Search orders..." className="pl-9 pr-4 py-2 bg-white border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500" />
              </div>
            </div>
            
            <div className="divide-y divide-slate-100">
              {pastOrders.map((order) => (
                <div key={order.id} className="p-6 hover:bg-slate-50 transition-colors flex flex-col md:flex-row gap-6 md:items-center justify-between group">
                  <div className="flex items-start gap-4 flex-1">
                    <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 shrink-0 border border-blue-100">
                      <ShoppingBag size={20} />
                    </div>
                    <div>
                      <div className="flex items-center gap-3 mb-1">
                        <h3 className="font-bold text-slate-900">Order #{order.id}</h3>
                        <span className={`px-2.5 py-0.5 rounded-full text-xs font-bold ${
                          order.status === 'Delivered' ? 'bg-emerald-100 text-emerald-700' : 'bg-amber-100 text-amber-700'
                        }`}>
                          {order.status}
                        </span>
                      </div>
                      <p className="text-sm text-slate-500 mb-1">{order.date} • {order.storeCount} Store(s)</p>
                      <p className="text-sm text-slate-700 line-clamp-1">{order.items}</p>
                    </div>
                  </div>
                  
                  <div className="flex items-center justify-between md:flex-col md:items-end gap-4 md:gap-2 shrink-0">
                    <span className="font-extrabold text-slate-900">${order.total.toFixed(2)}</span>
                    <button 
                      onClick={() => handleTrackOrder(order.id)}
                      className="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition-all shadow-sm group-hover:shadow-md active:scale-95 flex items-center gap-2"
                    >
                      <Package size={16} /> Track Order
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}

        {/* Interactive Tracking View */}
        {activeTab === 'tracking' && selectedOrder && (
          <motion.div 
            key="tracking"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="flex flex-col gap-6"
          >
            <button 
              onClick={() => setSelectedOrder(null)}
              className="inline-flex items-center text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors self-start"
            >
              <ArrowLeft size={16} className="mr-2" /> Back to Purchases
            </button>
            
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Timeline Container */}
              <div className="lg:col-span-2 bg-white border border-slate-200 rounded-3xl p-6 md:p-10 shadow-sm">
                <div className="flex justify-between items-start mb-10">
                  <div>
                    <h2 className="text-2xl font-bold text-slate-900 mb-2">Live Fulfillment Status</h2>
                    <p className="text-slate-500">Tracking Number: <span className="font-bold text-slate-900">{selectedOrder}</span></p>
                  </div>
                  <div className="hidden sm:block text-right">
                    <p className="text-sm text-slate-500 uppercase tracking-wider font-bold mb-1">Est. Delivery</p>
                    <p className="text-xl font-extrabold text-blue-600">Today, by 4:00 PM</p>
                  </div>
                </div>

                {/* Simulated Live Data Push Notice */}
                <div className="bg-blue-50 border border-blue-100 text-blue-800 px-4 py-3 rounded-xl text-sm font-medium mb-10 flex items-center gap-2">
                  <div className="w-2 h-2 bg-blue-600 rounded-full animate-pulse"></div>
                  Interactive Demo: Click on any step below to simulate a live data update from the driver/warehouse.
                </div>

                {/* Auto-layout Visual Timeline */}
                <div className="relative pl-6 md:pl-10 pb-6">
                  {/* The Background Line */}
                  <div className="absolute left-[33px] md:left-[49px] top-4 bottom-4 w-1 bg-slate-100 rounded-full"></div>
                  
                  {/* The Active Line (fills based on step) */}
                  <motion.div 
                    className="absolute left-[33px] md:left-[49px] top-4 w-1 bg-blue-600 rounded-full origin-top"
                    initial={{ height: 0 }}
                    animate={{ height: `${(trackingStep / (steps.length - 1)) * 100}%` }}
                    transition={{ duration: 0.5, ease: "easeInOut" }}
                  ></motion.div>

                  <div className="flex flex-col gap-12 relative z-10">
                    {steps.map((step) => {
                      const Icon = step.icon;
                      const isCompleted = trackingStep >= step.id;
                      const isActive = trackingStep === step.id;
                      const isPending = trackingStep < step.id;

                      return (
                        <div 
                          key={step.id} 
                          className="flex items-start gap-6 cursor-pointer group"
                          onClick={() => setTrackingStep(step.id)}
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
                            
                            {/* Pulsing ring for active state */}
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
                      )
                    })}
                  </div>
                </div>
              </div>

              {/* Sidebar */}
              <div className="flex flex-col gap-6">
                <div className="bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-xl text-white relative overflow-hidden">
                  <div className="absolute top-0 right-0 -mr-4 -mt-4 w-32 h-32 bg-blue-600 rounded-full opacity-20 blur-3xl"></div>
                  <h3 className="font-bold text-lg mb-6 flex items-center gap-2 relative z-10">
                    <ShieldCheck size={20} className="text-blue-400" /> Secure Delivery Code
                  </h3>
                  <div className="bg-slate-800/80 rounded-2xl p-4 text-center border border-slate-700 relative z-10 mb-4">
                    <p className="text-xs text-slate-400 uppercase tracking-widest font-bold mb-2">Provide to Driver</p>
                    <p className="text-4xl font-mono font-extrabold tracking-[0.2em] text-blue-400">8902</p>
                  </div>
                  <p className="text-sm text-slate-400 text-center relative z-10">To ensure secure handover, please provide this PIN to your LogiLink Courier.</p>
                </div>

                <div className="bg-white border border-slate-200 rounded-3xl p-6 shadow-sm">
                   <h3 className="font-bold text-slate-900 mb-4">Delivery Route</h3>
                   <div className="space-y-4 relative">
                     <div className="absolute left-[11px] top-4 bottom-4 w-0.5 bg-slate-100"></div>
                     <div className="flex gap-4 relative z-10">
                       <div className="w-6 h-6 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center shrink-0">
                         <div className="w-2 h-2 rounded-full bg-slate-400"></div>
                       </div>
                       <div>
                         <p className="text-xs font-bold text-slate-400 uppercase">Origin Stores</p>
                         <p className="text-sm font-medium text-slate-900">Tech Haven & Sneaker Hub</p>
                       </div>
                     </div>
                     <div className="flex gap-4 relative z-10">
                       <div className="w-6 h-6 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center shrink-0">
                         <MapPin size={12} className="text-blue-600" />
                       </div>
                       <div>
                         <p className="text-xs font-bold text-slate-400 uppercase">Destination</p>
                         <p className="text-sm font-medium text-slate-900">1423 Logic Avenue</p>
                       </div>
                     </div>
                   </div>
                </div>
              </div>
            </div>
          </motion.div>
        )}

      </AnimatePresence>
    </div>
  );
}
