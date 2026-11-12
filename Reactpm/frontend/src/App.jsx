// piezas de react-router-dom Routes/route define el mapa de rutas
// Navigate sirve para redirigir
import { Navigate, Route, Routes } from "react-router-dom";
import LoginPage from "./page/loadPage";
import { useAuth } from "./context/useAuth";

function App() {
  const { usuario, cerrarSesion } = useAuth();

  return (
    <Routes>
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/dashboard"
        element={
          usuario ? (
            <main className="container py-5">
              <h1 className="h3">Inventario React</h1>
              <p>Bienvenido, {usuario.nombre}.</p>
              <button className="btn btn-outline-primary" onClick={cerrarSesion}>
                Cerrar sesion
              </button>
            </main>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

export default App