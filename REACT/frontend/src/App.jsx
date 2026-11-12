// piezas de react-router-dom Routes/route define el mapa de rutas
// Navigate sirve para redirigir
import {Navigate, Route, Routes} from "react-router-dom"
import { useAuth } from "./context/authContext";
// Guardian que protege las rutas privadas del dashboard
//import ProtectedRoute from "./routes/ProtectedRoute";
// esqueleto visual (sidebar + topbar) que compartenlas paginas del dashboar
//import ProtectedRoute from "./routes/ProtectedRouted";

// Paginas publicas y privadas de la aplicacion
import LoginPage from "./page/loadPage";

function App() {
  const { usuario, cargando } = useAuth();
  
return (
    <Routes>
      {/* ruta raiz: manda directo al login (si ya hay sesion,
      protectedRoute se encarga de dejarlo pasar al dashboard*/}
      <Route path="/" element={<Navigate to="login" replace />}/>
      
      {/* ruta publica cualquiera puede entrar a login*/}
      <Route path="/login" element={<LoginPage />}/>

      {/* ruta privada: por ahora el dashboard permanece vacio */}
      <Route
        path="/dashboard"
        element={cargando || usuario ? null : <Navigate to="/login" replace />}
      />

      {/* cualquier otra url que no coincida con las anteriores */}
      <Route path="*" element={<Navigate to="/login" replace />}/>
    </Routes>
)
}
export default App