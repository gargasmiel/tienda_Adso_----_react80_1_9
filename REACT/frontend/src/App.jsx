import { Navigate, Route, Routes } from 'react-router-dom';
import LoginPage from './pages/LoginPage.jsx';
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
      <Route path="/dashboard" element= {<DashboardLayout />}>
      <Route index element={<DashboardHome/>}/>
      <Route path="usuarios"element={<UsuariosPage/>}/>
     
     </Route>
     </Route>
    </Routes>
    
  );
}
export default App;