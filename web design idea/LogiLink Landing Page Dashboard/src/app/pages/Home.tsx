import { useState, useEffect } from "react";
import { motion } from "motion/react";
import { ChevronRight, Star, ShoppingBag, Zap, Clock, TrendingUp } from "lucide-react";
import { Link } from "react-router";

export function Home() {
  const [addedItems, setAddedItems] = useState<number[]>([]);

  const handleAddToCart = (id: number) => {
    setAddedItems((prev) => [...prev, id]);
    // Simulate cart add effect
    setTimeout(() => {
      setAddedItems((prev) => prev.filter(item => item !== id));
    }, 2000);
  };

  const stores = [
    { id: 1, name: "Tech Haven", category: "Electronics", color: "bg-blue-100", icon: Zap },
    { id: 2, name: "Fresh Market", category: "Grocery", color: "bg-green-100", icon: Clock },
    { id: 3, name: "Urban Threads", category: "Apparel", color: "bg-purple-100", icon: TrendingUp },
    { id: 4, name: "Home Essentials", category: "Home Goods", color: "bg-orange-100", icon: ShoppingBag },
    { id: 5, name: "Sneaker Hub", category: "Footwear", color: "bg-red-100", icon: Star },
  ];

  const products = [
    { 
      id: 101, 
      title: "Noise-Canceling Wireless Headphones", 
      price: 299.00, 
      store: "Tech Haven", 
      image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBlbGVjdHJvbmljcyUyMGhlYWRwaG9uZXN8ZW58MXx8fHwxNzc5MDk2MjI4fDA&ixlib=rb-4.1.0&q=80&w=1080" 
    },
    { 
      id: 102, 
      title: "Organic Fresh Produce Box", 
      price: 45.50, 
      store: "Fresh Market", 
      image: "https://images.unsplash.com/photo-1542838132-92c53300491e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmcmVzaCUyMGdyb2NlcmllcyUyMHByb2R1Y2V8ZW58MXx8fHwxNzc5MDk2MjI4fDA&ixlib=rb-4.1.0&q=80&w=1080" 
    },
    { 
      id: 103, 
      title: "Urban Minimalist Jacket", 
      price: 120.00, 
      store: "Urban Threads", 
      image: "https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYXNoaW9uJTIwYXBwYXJlbCUyMGNsb3RoaW5nfGVufDF8fHx8MTc3OTA5NjIyOXww&ixlib=rb-4.1.0&q=80&w=1080" 
    },
    { 
      id: 104, 
      title: "Pro Smartphone 2024", 
      price: 999.00, 
      store: "Tech Haven", 
      image: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzbWFydHBob25lJTIwZ2FkZ2V0fGVufDF8fHx8MTc3OTA5NjIzNnww&ixlib=rb-4.1.0&q=80&w=1080" 
    },
    { 
      id: 105, 
      title: "Classic Runner Sneakers", 
      price: 150.00, 
      store: "Sneaker Hub", 
      image: "https://images.unsplash.com/photo-1560769629-975ec94e6a86?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzbmVha2VycyUyMHNob2VzfGVufDF8fHx8MTc3OTAzMDUwNnww&ixlib=rb-4.1.0&q=80&w=1080" 
    },
    { 
      id: 106, 
      title: "Smart Delivery Tracker", 
      price: 39.99, 
      store: "Tech Haven", 
      image: "https://images.unsplash.com/photo-1543499459-d1460946bdc6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkZWxpdmVyeSUyMGNvdXJpZXIlMjBhcHB8ZW58MXx8fHwxNzc5MDk2MjI5fDA&ixlib=rb-4.1.0&q=80&w=1080" 
    },
  ];

  return (
    <div className="flex flex-col w-full pb-20 bg-slate-50">
      
      {/* Hero Banner Area */}
      <section className="pt-6 pb-10 px-4">
        <div className="container mx-auto">
          <div className="relative rounded-3xl overflow-hidden bg-slate-900 shadow-2xl h-[360px] md:h-[420px] flex items-center group cursor-pointer">
            <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1543499459-d1460946bdc6?q=80&w=2000&auto=format&fit=crop')] bg-cover bg-center opacity-30 group-hover:opacity-40 transition-opacity duration-700"></div>
            <div className="absolute inset-0 bg-gradient-to-r from-slate-900 via-slate-900/80 to-transparent"></div>
            
            <div className="relative z-10 p-8 md:p-16 max-w-2xl">
              <motion.span 
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className="inline-block py-1.5 px-4 rounded-full bg-blue-600/20 text-blue-400 font-bold text-xs tracking-wider uppercase mb-6 backdrop-blur-md border border-blue-500/30"
              >
                LogiLink Marketplace
              </motion.span>
              <motion.h1 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-white leading-tight mb-4"
              >
                Shop local stores,<br />
                <span className="text-blue-500">get same-day delivery.</span>
              </motion.h1>
              <motion.p 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
                className="text-slate-300 text-lg md:text-xl mb-8"
              >
                Combine your favorite local purchases into one unified cart, delivered at the speed of light.
              </motion.p>
              
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
              >
                <Link to="/checkout" className="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-500 text-white font-semibold py-4 px-8 rounded-xl transition-all shadow-lg shadow-blue-600/30">
                  Start Shopping
                  <ChevronRight size={20} />
                </Link>
              </motion.div>
            </div>
          </div>
        </div>
      </section>

      {/* Store Directory */}
      <section className="py-8 border-y border-slate-200/60 bg-white">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl md:text-2xl font-bold text-slate-900">Partner Stores</h2>
            <button className="text-sm font-semibold text-blue-600 hover:text-blue-700 flex items-center gap-1">
              View All <ChevronRight size={16} />
            </button>
          </div>
          
          <div className="flex overflow-x-auto pb-4 -mx-4 px-4 gap-4 snap-x snap-mandatory hide-scrollbar" style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}>
            {stores.map((store) => {
              const StoreIcon = store.icon;
              return (
                <div key={store.id} className="snap-start shrink-0 w-44 md:w-56 group cursor-pointer">
                  <div className="bg-slate-50 border border-slate-100 p-6 rounded-2xl transition-all duration-300 group-hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)] group-hover:-translate-y-1 group-hover:border-blue-100 flex flex-col items-center text-center gap-4">
                    <div className={`w-14 h-14 rounded-full ${store.color} flex items-center justify-center text-slate-800 group-hover:scale-110 transition-transform`}>
                      <StoreIcon size={24} className="opacity-80" />
                    </div>
                    <div>
                      <h3 className="font-bold text-slate-900 text-sm md:text-base">{store.name}</h3>
                      <p className="text-xs text-slate-500 font-medium mt-1">{store.category}</p>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Featured Products */}
      <section className="py-12 md:py-16">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-8">
            <h2 className="text-2xl md:text-3xl font-bold text-slate-900">Trending Now</h2>
            <button className="text-sm font-semibold text-slate-500 hover:text-slate-900 bg-white px-4 py-2 border border-slate-200 rounded-lg shadow-sm transition-all">
              Filter By
            </button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {products.map((product) => (
              <div key={product.id} className="bg-white rounded-2xl border border-slate-200 overflow-hidden hover:shadow-xl hover:shadow-slate-200/50 transition-all duration-300 flex flex-col group">
                <div className="relative h-56 overflow-hidden bg-slate-100">
                  <img 
                    src={product.image} 
                    alt={product.title} 
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                  />
                  <div className="absolute top-3 left-3 bg-white/90 backdrop-blur text-xs font-bold text-slate-700 py-1.5 px-3 rounded-full shadow-sm flex items-center gap-1.5">
                    <ShoppingBag size={12} className="text-blue-600" />
                    {product.store}
                  </div>
                </div>
                
                <div className="p-5 flex flex-col flex-1">
                  <div className="flex-1">
                    <h3 className="font-bold text-slate-900 text-lg leading-tight mb-2 line-clamp-2">
                      {product.title}
                    </h3>
                    <p className="text-2xl font-extrabold text-slate-900">
                      ${product.price.toFixed(2)}
                    </p>
                  </div>
                  
                  <button 
                    onClick={() => handleAddToCart(product.id)}
                    className={`mt-6 w-full py-3 rounded-xl font-bold text-sm transition-all flex items-center justify-center gap-2
                      ${addedItems.includes(product.id) 
                        ? 'bg-emerald-50 text-emerald-600 border border-emerald-200' 
                        : 'bg-blue-600 hover:bg-blue-700 text-white shadow-md shadow-blue-600/20'
                      }`}
                  >
                    {addedItems.includes(product.id) ? (
                      <>
                        <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }}>
                          <Star size={18} className="fill-emerald-600 text-emerald-600" />
                        </motion.div>
                        Added to Cart
                      </>
                    ) : (
                      <>
                        Add to Cart
                      </>
                    )}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
      
      {/* CSS for hiding scrollbar directly applied via inline style for safety, but can also use this global class in tailwind */}
      <style>{`
        .hide-scrollbar::-webkit-scrollbar {
          display: none;
        }
      `}</style>
    </div>
  );
}
