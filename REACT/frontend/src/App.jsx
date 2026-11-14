import { Navigate, Route, Routes } from 'react-router-dom';
import LoginPage from './pages/LoginPage.jsx';
import ProtectedRoute from './routes/ProctetedRoutes.jsx';
import DashboardLayout from './layoust/DahsboardLayout.jsx';
function NotFoundPage() {
  return <h1 className="text-center mt-5">Pagina no encontrada</h1>
}

function App() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="*" element={<NotFoundPage />} />
      {/*Grupo de rutas protegidas; todo lo que este dentro de este
      route solo muestra si protectedroute codnfirma que  hay secion activa; si no redirige a /*login/ */}
      <Route element={<ProtectedRoute/>}>
      <Route path="/dashboard" element={<DashboardLayout />} />

    </Route>
    </Routes>

  );
}
export default App;
