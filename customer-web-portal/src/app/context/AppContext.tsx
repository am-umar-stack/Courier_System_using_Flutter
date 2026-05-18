import React, { createContext, useContext, useState, useEffect } from "react";

export interface CartItem {
  id: number;
  title: string;
  price: number;
  store: string;
  image: string;
  qty: number;
}

export interface DriverInfo {
  name: string;
  phone: string;
  avatar: string;
}

export interface OrderItem {
  id: string;
  date: string;
  status: "Pending" | "In Transit" | "Out for Delivery" | "Delivered";
  total: number;
  shippingFee: number;
  shippingTier: "standard" | "express" | "instant";
  storeCount: number;
  itemsText: string;
  itemDetails: {
    id: number;
    title: string;
    price: number;
    qty: number;
    image: string;
    store: string;
  }[];
  pin: string;
  driver: DriverInfo;
  trackingStep: number; // 0: Pending, 1: In Transit, 2: Out, 3: Delivered
  origin: string;
  destination: string;
}

interface AppContextType {
  cart: CartItem[];
  orders: OrderItem[];
  addToCart: (product: { id: number; title: string; price: number; store: string; image: string }) => void;
  removeFromCart: (productId: number) => void;
  updateCartQty: (productId: number, qty: number) => void;
  clearCart: () => void;
  placeOrder: (shippingTier: "standard" | "express" | "instant", address: { name: string; street: string; city: string }) => string;
  updateOrderTrackingStep: (orderId: string, step: number) => void;
  findOrderById: (orderId: string) => OrderItem | undefined;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

const DEFAULT_DRIVERS: DriverInfo[] = [
  { name: "Alex Kumar", phone: "+1 (555) 492-8902", avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop" },
  { name: "Sarah Jenkins", phone: "+1 (555) 381-3142", avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop" },
  { name: "Marcus Brody", phone: "+1 (555) 902-7619", avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop" },
  { name: "David Miller", phone: "+1 (555) 128-4091", avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop" },
  { name: "Elena Rostova", phone: "+1 (555) 762-1130", avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop" }
];

const PRELOADED_ORDERS: OrderItem[] = [
  {
    id: 'AMU-10582',
    date: 'Today, 10:23 AM',
    status: 'In Transit',
    total: 464.00,
    shippingFee: 15.00,
    shippingTier: 'express',
    storeCount: 2,
    itemsText: 'Noise-Canceling Headphones, Sneakers',
    itemDetails: [
      { id: 101, title: "Noise-Canceling Wireless Headphones", price: 299.00, qty: 1, image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200", store: "Tech Haven" },
      { id: 105, title: "Classic Runner Sneakers", price: 150.00, qty: 1, image: "https://images.unsplash.com/photo-1560769629-975ec94e6a86?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200", store: "Sneaker Hub" }
    ],
    pin: '8902',
    driver: DEFAULT_DRIVERS[0],
    trackingStep: 1,
    origin: 'Tech Haven & Sneaker Hub',
    destination: 'John Doe, 1423 Logic Avenue, Suite 300, Los Angeles, CA 90001'
  },
  {
    id: 'AMU-09214',
    date: 'Yesterday, 4:15 PM',
    status: 'Delivered',
    total: 120.00,
    shippingFee: 0.00,
    shippingTier: 'standard',
    storeCount: 1,
    itemsText: 'Urban Minimalist Jacket',
    itemDetails: [
      { id: 103, title: "Urban Minimalist Jacket", price: 120.00, qty: 1, image: "https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200", store: "Urban Threads" }
    ],
    pin: '3142',
    driver: DEFAULT_DRIVERS[1],
    trackingStep: 3,
    origin: 'Urban Threads',
    destination: 'John Doe, 1423 Logic Avenue, Suite 300, Los Angeles, CA 90001'
  },
  {
    id: 'AMU-08831',
    date: 'Oct 05, 2025',
    status: 'Delivered',
    total: 45.50,
    shippingFee: 5.00,
    shippingTier: 'standard',
    storeCount: 1,
    itemsText: 'Organic Fresh Produce Box',
    itemDetails: [
      { id: 102, title: "Organic Fresh Produce Box", price: 40.50, qty: 1, image: "https://images.unsplash.com/photo-1542838132-92c53300491e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=200", store: "Fresh Market" }
    ],
    pin: '7619',
    driver: DEFAULT_DRIVERS[2],
    trackingStep: 3,
    origin: 'Fresh Market',
    destination: 'John Doe, 1423 Logic Avenue, Suite 300, Los Angeles, CA 90001'
  }
];

export const AppProvider = ({ children }: { children: React.ReactNode }) => {
  const [cart, setCart] = useState<CartItem[]>(() => {
    const savedCart = localStorage.getItem("amu_cart");
    return savedCart ? JSON.parse(savedCart) : [];
  });

  const [orders, setOrders] = useState<OrderItem[]>(() => {
    const savedOrders = localStorage.getItem("amu_orders");
    return savedOrders ? JSON.parse(savedOrders) : PRELOADED_ORDERS;
  });

  useEffect(() => {
    localStorage.setItem("amu_cart", JSON.stringify(cart));
  }, [cart]);

  useEffect(() => {
    localStorage.setItem("amu_orders", JSON.stringify(orders));
  }, [orders]);

  const addToCart = (product: { id: number; title: string; price: number; store: string; image: string }) => {
    setCart((prevCart: CartItem[]) => {
      const existingItem = prevCart.find((item: CartItem) => item.id === product.id);
      if (existingItem) {
        return prevCart.map((item: CartItem) =>
          item.id === product.id ? { ...item, qty: item.qty + 1 } : item
        );
      }
      return [...prevCart, { ...product, qty: 1 }];
    });
  };

  const removeFromCart = (productId: number) => {
    setCart((prevCart: CartItem[]) => prevCart.filter((item: CartItem) => item.id !== productId));
  };

  const updateCartQty = (productId: number, qty: number) => {
    if (qty <= 0) {
      removeFromCart(productId);
      return;
    }
    setCart((prevCart: CartItem[]) =>
      prevCart.map((item: CartItem) => (item.id === productId ? { ...item, qty } : item))
    );
  };

  const clearCart = () => {
    setCart([]);
  };

  const placeOrder = (
    shippingTier: "standard" | "express" | "instant",
    address: { name: string; street: string; city: string }
  ) => {
    const shippingOptions = {
      standard: 5.00,
      express: 15.00,
      instant: 25.00,
    };

    const shippingFee = shippingOptions[shippingTier];
    const subtotal = cart.reduce((sum: number, item: CartItem) => sum + item.price * item.qty, 0);
    const total = subtotal + shippingFee;

    // Determine stores involved
    const uniqueStores = Array.from(new Set(cart.map((item: CartItem) => item.store)));
    const storeCount = uniqueStores.length;
    const origin = uniqueStores.join(" & ");
    
    // Create items summary text
    const itemsText = cart.map((item: CartItem) => item.title.split(" ").slice(0, 3).join(" ")).join(", ");

    // Generate Order ID
    const randomNum = Math.floor(10000 + Math.random() * 90000);
    const orderId = `AMU-${randomNum}`;

    // Generate PIN
    const pin = Math.floor(1000 + Math.random() * 9000).toString();

    // Assign random driver
    const driver = DEFAULT_DRIVERS[Math.floor(Math.random() * DEFAULT_DRIVERS.length)];

    const newOrder: OrderItem = {
      id: orderId,
      date: `Today, ${new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`,
      status: "Pending",
      total,
      shippingFee,
      shippingTier,
      storeCount,
      itemsText,
      itemDetails: cart.map((item: CartItem) => ({
        id: item.id,
        title: item.title,
        price: item.price,
        qty: item.qty,
        image: item.image,
        store: item.store
      })),
      pin,
      driver,
      trackingStep: 0,
      origin,
      destination: `${address.name}, ${address.street}, ${address.city}`
    };

    setOrders((prevOrders: OrderItem[]) => [newOrder, ...prevOrders]);
    clearCart();
    return orderId;
  };

  const updateOrderTrackingStep = (orderId: string, step: number) => {
    const statuses: OrderItem["status"][] = ["Pending", "In Transit", "Out for Delivery", "Delivered"];
    setOrders((prevOrders: OrderItem[]) =>
      prevOrders.map((order: OrderItem) => {
        if (order.id === orderId) {
          const clampedStep = Math.max(0, Math.min(3, step));
          return {
            ...order,
            trackingStep: clampedStep,
            status: statuses[clampedStep]
          };
        }
        return order;
      })
    );
  };

  const findOrderById = (orderId: string) => {
    return orders.find(
      (order: OrderItem) => order.id.toUpperCase() === orderId.toUpperCase()
    );
  };

  return (
    <AppContext.Provider
      value={{
        cart,
        orders,
        addToCart,
        removeFromCart,
        updateCartQty,
        clearCart,
        placeOrder,
        updateOrderTrackingStep,
        findOrderById,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useAppContext = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error("useAppContext must be used within an AppProvider");
  }
  return context;
};
