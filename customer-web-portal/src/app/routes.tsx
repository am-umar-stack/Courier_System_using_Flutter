import { createBrowserRouter, Outlet } from "react-router";
import { Header } from "./components/Header";
import { Home } from "./pages/Home";
import { Dashboard } from "./pages/Dashboard";
import { Checkout } from "./pages/Checkout";

function Root() {
  return (
    <div className="min-h-screen bg-slate-50 font-sans text-slate-900 selection:bg-blue-600/30 flex flex-col">
      <Header />
      <main className="flex-1 flex flex-col">
        <Outlet />
      </main>
      <footer className="bg-slate-900 py-12 text-slate-400 text-center text-sm mt-auto border-t border-slate-800">
        <div className="container mx-auto px-4">
          <p>© {new Date().getFullYear()} AMU Courier Platform. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: Home },
      { path: "checkout", Component: Checkout },
      { path: "dashboard", Component: Dashboard },
    ],
  },
]);
