import { useState } from "react";
import { ArrowLeft, MapPin, Truck, Zap, Package, ShieldCheck, Info, ShoppingBag } from "lucide-react";
import { Link, useNavigate } from "react-router";
import * as RadioGroup from "@radix-ui/react-radio-group";
import { useAppContext } from "../context/AppContext";

export function Checkout() {
  const navigate = useNavigate();
  const { cart, placeOrder, addToCart } = useAppContext();
  const [shippingTier, setShippingTier] = useState<"standard" | "express" | "instant">("express");
  
  // Interactive Address Fields
  const [address, setAddress] = useState({
    name: "John Doe",
    street: "1423 Logic Avenue, Suite 300",
    city: "Los Angeles, CA 90001"
  });
  
  const [isEditingAddress, setIsEditingAddress] = useState(false);

  // Group items by store for the visual display
  const groupedCart: { store: string; items: typeof cart }[] = [];
  cart.forEach((item) => {
    const existingStore = groupedCart.find((g) => g.store === item.store);
    if (existingStore) {
      existingStore.items.push(item);
    } else {
      groupedCart.push({ store: item.store, items: [item] });
    }
  });

  const itemSubtotal = cart.reduce((sum: number, item: any) => sum + item.price * item.qty, 0);
  
  const shippingOptions: Record<"standard" | "express" | "instant", { label: string; fee: number; icon: any }> = {
    standard: { label: "Standard (2-3 Days)", fee: 5.00, icon: Package },
    express: { label: "Express (Tomorrow)", fee: 15.00, icon: Truck },
    instant: { label: "Same-Day Delivery", fee: 25.00, icon: Zap },
  };

  const currentShippingFee = shippingOptions[shippingTier].fee;
  const total = itemSubtotal + currentShippingFee;

  const handleCheckoutSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (cart.length === 0) return;
    
    // Call placeOrder to generate order ID and store it in state / local storage
    const orderId = placeOrder(shippingTier, address);
    
    // Redirect directly to dashboard with the new tracking ID in query parameters
    navigate(`/dashboard?track=${orderId}`);
  };

  const handlePreloadDemo = () => {
    // Add default headphones and sneakers
    addToCart({
      id: 101,
      title: "Noise-Canceling Wireless Headphones",
      price: 299.00,
      store: "Tech Haven",
      image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200"
    });
    addToCart({
      id: 105,
      title: "Classic Runner Sneakers",
      price: 150.00,
      store: "Sneaker Hub",
      image: "https://images.unsplash.com/photo-1560769629-975ec94e6a86?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200"
    });
  };

  if (cart.length === 0) {
    return (
      <div className="container mx-auto px-4 py-16 max-w-2xl text-center">
        <div className="w-20 h-20 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-6 border border-blue-100">
          <ShoppingBag size={36} />
        </div>
        <h1 className="text-3xl font-bold text-slate-900 mb-2">Your Cart is Empty</h1>
        <p className="text-slate-500 mb-8 max-w-md mx-auto">You haven't added any products to your cart yet. Browse our marketplace to shop from local stores with same-day shipping!</p>
        
        <div className="flex flex-col sm:flex-row justify-center gap-4">
          <Link to="/" className="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-8 rounded-xl transition-all shadow-md shadow-blue-600/20">
            Browse Marketplace
          </Link>
          <button 
            onClick={handlePreloadDemo}
            className="bg-white hover:bg-slate-50 text-slate-700 font-semibold py-3 px-8 rounded-xl border border-slate-200 shadow-sm transition-all"
          >
            Preload Demo Items
          </button>
        </div>
      </div>
    );
  }

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
              <button 
                onClick={() => setIsEditingAddress(!isEditingAddress)} 
                className="text-sm font-semibold text-blue-600 hover:text-blue-700"
              >
                {isEditingAddress ? "Done" : "Edit"}
              </button>
            </div>
            
            <div className="bg-slate-50 border border-slate-100 rounded-xl p-6 flex gap-4">
              <div className="flex-1">
                {isEditingAddress ? (
                  <div className="space-y-4">
                    <div>
                      <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Full Name</label>
                      <input 
                        type="text" 
                        value={address.name}
                        onChange={(e) => setAddress({...address, name: e.target.value})}
                        className="w-full bg-white border border-slate-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Street Address</label>
                      <input 
                        type="text" 
                        value={address.street}
                        onChange={(e) => setAddress({...address, street: e.target.value})}
                        className="w-full bg-white border border-slate-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-400 uppercase mb-1">City, State, ZIP</label>
                      <input 
                        type="text" 
                        value={address.city}
                        onChange={(e) => setAddress({...address, city: e.target.value})}
                        className="w-full bg-white border border-slate-200 rounded-lg p-2.5 text-sm focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20"
                      />
                    </div>
                  </div>
                ) : (
                  <>
                    <p className="font-bold text-slate-900">{address.name}</p>
                    <p className="text-slate-600 text-sm mt-1">{address.street}<br/>{address.city}</p>
                    <p className="text-slate-500 text-sm mt-3 flex items-center gap-1.5 font-medium">
                      <ShieldCheck size={14} className="text-emerald-500" />
                      Address Verified
                    </p>
                  </>
                )}
              </div>
            </div>
          </div>

          {/* Cart Items Grouped by Store */}
          <div className="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">
            <div className="p-6 border-b border-slate-100 bg-slate-50/50">
              <h2 className="text-lg font-bold text-slate-900">Order Summary ({groupedCart.length} Stores)</h2>
            </div>
            
            <div className="divide-y divide-slate-100">
              {groupedCart.map((storeGroup, idx) => (
                <div key={idx} className="p-6">
                  <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                    {storeGroup.store}
                  </h3>
                  
                  <div className="space-y-4">
                    {storeGroup.items.map((item: any) => (
                      <div key={item.id} className="flex gap-4">
                        <div className="w-20 h-20 bg-slate-100 rounded-xl overflow-hidden shrink-0 border border-slate-200">
                          <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                        </div>
                        <div className="flex-1 flex flex-col justify-center">
                          <h4 className="font-semibold text-slate-900 text-sm line-clamp-2">{item.title}</h4>
                          <p className="text-slate-500 text-sm mt-1">Qty: {item.qty}</p>
                          <p className="font-bold text-slate-900 mt-1">${(item.price * item.qty).toFixed(2)}</p>
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
                  onValueChange={(val) => setShippingTier(val as "standard" | "express" | "instant")}
                >
                  {Object.entries(shippingOptions).map(([key, option]) => {
                    const OptionIcon = option.icon;
                    const isActive = shippingTier === key;
                    return (
                      <RadioGroup.Item 
                        key={key} 
                        value={key} 
                        className={`relative w-full flex items-center justify-between p-4 rounded-xl border-2 transition-all text-left outline-none cursor-pointer
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
                            <p className="text-slate-500 text-xs mt-0.5">AMU Courier</p>
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

              <button 
                onClick={handleCheckoutSubmit}
                className="w-full bg-blue-600 hover:bg-blue-700 text-white py-4 rounded-xl font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-blue-600/30 cursor-pointer"
              >
                Confirm & Pay
                <ArrowLeft size={18} className="rotate-180" />
              </button>
              
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
