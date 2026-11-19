import { createContext, useContext, useEffect, useState } from 'react';
import { iniciarSesion } from '../api/authService';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [usuario, setUsuario] = useState(null);
    const [cargando, setCargando] = useState(true);

    useEffect(() => {
        const usuarioGuardado = localStorage.getItem('usuario');
        const tokenGuardado = localStorage.getItem('token');

        if (usuarioGuardado && tokenGuardado) {
            try {
                setUsuario(JSON.parse(usuarioGuardado));
            } catch {
                localStorage.removeItem('usuario');
                localStorage.removeItem('token');
            }
        }

        setCargando(false);
    }, []);

    async function login(email, password) {
        const sesion = await iniciarSesion(email, password);
        localStorage.setItem('token', sesion.token);
        localStorage.setItem('usuario', JSON.stringify(sesion.usuario));
        setUsuario(sesion.usuario);
        return sesion;
    }

    function logout() {
        localStorage.removeItem('token');
        localStorage.removeItem('usuario');
        setUsuario(null);
    }

    return (
        <AuthContext.Provider value={{ usuario, estaAutenticado: Boolean(usuario), cargando, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const contexto = useContext(AuthContext);
    if (!contexto) {
        throw new Error('useAuth debe usarse dentro de AuthProvider');
    }
    return contexto;
}

export default AuthContext;