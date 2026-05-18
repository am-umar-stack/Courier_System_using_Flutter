import { Link, useNavigate } from "react-router";
import { Package, Menu, X, ShoppingCart, User, Search } from "lucide-react";
import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";

export function Header() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const navigate = useNavigate();

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    // In a real app, this would search the marketplace
  };

  return (
    <header className="sticky top-0 z-50 w-full border-b border-slate-200/50 bg-white/80 backdrop-blur-xl">
      <div className="container mx-auto px-4 h-16 sm:h-20 flex items-center justify-between gap-4 lg:gap-8">
        <Link to="/" className="flex items-center gap-2 group shrink-0">
          <div className="bg-blue-600 p-2 rounded-xl text-white group-hover:bg-blue-700 transition-colors">
            <Package size={24} className="stroke-[2.5]" />
          </div>
          <span className="text-xl font-bold tracking-tight text-slate-900 hidden sm:block">
            Logi<span className="text-blue-600">Link</span>
          </span>
        </Link>

        {/* Search Bar */}
        <div className="flex-1 max-w-xl hidden md:block">
          <form onSubmit={handleSearch} className="relative group">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors" size={18} />
            <input 
              type="text" 
              placeholder="Search products, stores, or tracking numbers..." 
              className="w-full bg-slate-100 border border-transparent rounded-full py-2.5 pl-10 pr-4 text-sm focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 transition-all text-slate-900 placeholder:text-slate-500"
            />
          </form>
        </div>

        {/* Desktop Nav */}
        <div className="hidden md:flex items-center gap-6 shrink-0">
          <Link to="/dashboard" className="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">Track Shipment</Link>
          
          <div className="h-6 w-px bg-slate-200"></div>

          <Link to="/checkout" className="relative text-slate-600 hover:text-blue-600 transition-colors p-2">
            <ShoppingCart size={22} />
            <span className="absolute top-0 right-0 bg-blue-600 text-white text-[10px] font-bold h-4 w-4 rounded-full flex items-center justify-center border-2 border-white">
              2
            </span>
          </Link>
          
          <Link to="/dashboard" className="w-9 h-9 rounded-full bg-slate-100 flex items-center justify-center border-2 border-slate-200 hover:border-blue-500 transition-all overflow-hidden cursor-pointer">
            <img 
              src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop" 
              alt="User profile" 
              className="w-full h-full object-cover"
            />
          </Link>
        </div>

        {/* Mobile Toggle */}
        <div className="flex md:hidden items-center gap-4">
          <Link to="/checkout" className="relative text-slate-600 p-2">
            <ShoppingCart size={22} />
            <span className="absolute top-0 right-0 bg-blue-600 text-white text-[10px] font-bold h-4 w-4 rounded-full flex items-center justify-center border-2 border-white">
              2
            </span>
          </Link>
          <button 
            className="p-2 text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
          >
            {isMobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      <AnimatePresence>
        {isMobileMenuOpen && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="md:hidden border-t border-slate-100 bg-white overflow-hidden"
          >
            <div className="container mx-auto px-4 py-4 flex flex-col gap-4">
              <form onSubmit={handleSearch} className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                <input 
                  type="text" 
                  placeholder="Search..." 
                  className="w-full bg-slate-100 border border-transparent rounded-xl py-3 pl-10 pr-4 focus:outline-none focus:bg-white focus:border-blue-500 transition-all"
                />
              </form>
              <Link to="/dashboard" onClick={() => setIsMobileMenuOpen(false)} className="text-base font-medium text-slate-700 p-3 hover:bg-slate-50 rounded-xl flex items-center gap-3">
                <Package size={20} className="text-blue-600" /> Track Shipment
              </Link>
              <Link to="/dashboard" onClick={() => setIsMobileMenuOpen(false)} className="text-base font-medium text-slate-700 p-3 hover:bg-slate-50 rounded-xl flex items-center gap-3">
                <User size={20} className="text-slate-400" /> Account Profile
              </Link>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </header>
  );
}
