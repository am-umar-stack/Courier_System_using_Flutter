import { useState } from "react";
import { ArrowLeft, MapPin, Truck, Zap, Package, ShieldCheck, Info } from "lucide-react";
import { Link } from "react-router";
import * as RadioGroup from "@radix-ui/react-radio-group";

export function Checkout() {
  const [shippingTier, setShippingTier] = useState("express");

  const cartItems = [
    {
      store: "Tech Haven",
      items: [
        { id: 101, title: "Noise-Canceling Wireless Headphones", price: 299.00, qty: 1, image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200" },
      ]
    },
    {
      store: "Sneaker Hub",
      items: [
        { id: 105, title: "Classic Runner Sneakers", price: 150.00, qty: 1, image: "https://images.unsplash.com/photo-1560769629-975ec94e6a86?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200" }
      ]
    }
  ];

  const itemSubtotal = 449.00;
  
  const shippingOptions = {
    standard: { label: "Standard (2-3 Days)", fee: 5.00, icon: Package },
    express: { label: "Express (Tomorrow)", fee: 15.00, icon: Truck },
    instant: { label: "Same-Day Delivery", fee: 25.00, icon: Zap },
  };

  const currentShippingFee = shippingOptions[shippingTier as keyof typeof shippingOptions].fee;
  const total = itemSubtotal + currentShippingFee;

  return (
    <div className="container mx-auto px-4 py-8 max-w-6xl">
      <div className="mb-8">
        <Link to="/" className="inline-flex items-center text-sm font-semibold text-slate-500 hover:text-slate-900 transition-colors mb-4">
          <ArrowLeft size={16} className="mr-2" /> Back to Marketplace
        </Link>
        <h1 className="text-3xl font-bold text-slate-900">Secure Checkout</h1>
      </div>

      <div className="flex flex-col lg:flex-row gap-8 lg:gap-12">
        {/* Left Column: Cart Items & Address */}
        <div className="flex-1 space-y-8">
          
          {/* Delivery Address Block */}
          <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
                <MapPin className="text-blue-600" size={20} />
                Delivery Address
              </h2>
              <button className="text-sm font-semibold text-blue-600 hover:text-blue-700">Edit</button>
            </div>
            
            <div className="bg-slate-50 border border-slate-100 rounded-xl p-4 flex gap-4">
              <div className="flex-1">
                <p className="font-bold text-slate-900">John Doe</p>
                <p className="text-slate-600 text-sm mt-1">1423 Logic Avenue, Suite 300<br/>Los Angeles, CA 90001</p>
                <p className="text-slate-500 text-sm mt-2 flex items-center gap-1.5">
                  <ShieldCheck size={14} className="text-emerald-500" />
                  Address Verified
                </p>
              </div>
            </div>
          </div>

          {/* Cart Items Grouped by Store */}
          <div className="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">
            <div className="p-6 border-b border-slate-100 bg-slate-50/50">
              <h2 className="text-lg font-bold text-slate-900">Order Summary ({cartItems.length} Stores)</h2>
            </div>
            
            <div className="divide-y divide-slate-100">
              {cartItems.map((storeGroup, idx) => (
                <div key={idx} className="p-6">
                  <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                    {storeGroup.store}
                  </h3>
                  
                  <div className="space-y-4">
                    {storeGroup.items.map((item) => (
                      <div key={item.id} className="flex gap-4">
                        <div className="w-20 h-20 bg-slate-100 rounded-xl overflow-hidden shrink-0 border border-slate-200">
                          <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                        </div>
                        <div className="flex-1 flex flex-col justify-center">
                          <h4 className="font-semibold text-slate-900 text-sm line-clamp-2">{item.title}</h4>
                          <p className="text-slate-500 text-sm mt-1">Qty: {item.qty}</p>
                          <p className="font-bold text-slate-900 mt-1">${item.price.toFixed(2)}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Right Column: Checkout Billing & Fulfillment */}
        <div className="w-full lg:w-[400px]">
          <div className="bg-white border border-slate-200 rounded-2xl shadow-sm sticky top-24">
            <div className="p-6 border-b border-slate-100">
              <h2 className="text-lg font-bold text-slate-900">Fulfillment Options</h2>
              
              <div className="mt-6">
                <RadioGroup.Root 
                  className="flex flex-col gap-3" 
                  value={shippingTier} 
                  onValueChange={setShippingTier}
                >
                  {Object.entries(shippingOptions).map(([key, option]) => {
                    const OptionIcon = option.icon;
                    const isActive = shippingTier === key;
                    return (
                      <RadioGroup.Item 
                        key={key} 
                        value={key} 
                        className={`relative flex items-center justify-between p-4 rounded-xl border-2 transition-all text-left outline-none
                          ${isActive ? 'border-blue-600 bg-blue-50/50' : 'border-slate-200 bg-white hover:border-slate-300'}
                        `}
                      >
                        <div className="flex items-center gap-3">
                          <div className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors
                            ${isActive ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-500'}
                          `}>
                            <OptionIcon size={18} />
                          </div>
                          <div>
                            <p className={`font-bold text-sm ${isActive ? 'text-slate-900' : 'text-slate-700'}`}>{option.label}</p>
                            <p className="text-slate-500 text-xs mt-0.5">LogiLink Courier</p>
                          </div>
                        </div>
                        <span className={`font-bold ${isActive ? 'text-blue-600' : 'text-slate-900'}`}>
                          ${option.fee.toFixed(2)}
                        </span>
                        
                        {isActive && (
                          <div className="absolute -top-2 -right-2 w-5 h-5 bg-blue-600 rounded-full flex items-center justify-center border-2 border-white shadow-sm">
                            <div className="w-2 h-2 bg-white rounded-full"></div>
                          </div>
                        )}
                      </RadioGroup.Item>
                    );
                  })}
                </RadioGroup.Root>
              </div>
            </div>

            <div className="p-6 bg-slate-50/50">
              <div className="space-y-3 mb-6">
                <div className="flex justify-between text-slate-600 text-sm">
                  <span>Subtotal</span>
                  <span className="font-medium text-slate-900">${itemSubtotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-slate-600 text-sm">
                  <span className="flex items-center gap-1">Fulfillment Fee <Info size={14} className="text-slate-400" /></span>
                  <span className="font-medium text-slate-900">${currentShippingFee.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-slate-600 text-sm">
                  <span>Taxes</span>
                  <span className="font-medium text-slate-900">$0.00</span>
                </div>
              </div>

              <div className="border-t border-slate-200 pt-4 mb-6 flex justify-between items-center">
                <span className="font-bold text-slate-900 text-lg">Total</span>
                <span className="font-extrabold text-blue-600 text-2xl">${total.toFixed(2)}</span>
              </div>

              <Link to="/dashboard" className="w-full bg-blue-600 hover:bg-blue-700 text-white py-4 rounded-xl font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-blue-600/30">
                Confirm & Pay
                <ArrowLeft size={18} className="rotate-180" />
              </Link>
              
              <p className="text-center text-xs text-slate-400 mt-4 flex items-center justify-center gap-1">
                <ShieldCheck size={14} /> Encrypted and Secure
              </p>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
