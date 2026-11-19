import { NavLink } from 'react-router-dom';

/**
 * menu lateral del dahsboard una <navlink> de react-router-dom
 * en vez de <link> porque <navlink> sabe automaticamente cuando su ruta esta activa 
 * (la url actual coincide) y nos deja pintarla
 * destino(clase"active")
 */
//lista de items del menu mientras mas crece el dahsboard, solo hay que agregar un objeto aca (evita repetir el mismo <navlink> 5 veces)

const opcionesMenu =[
    {texto: 'Inicio', ruta:'/dashboard', icono:'bi-house-door', fin: true},
    {texto: 'Usuarios', ruta:'/dashboard/usuarios', icono:'bi-people'},
    {texto: 'Categorias', ruta:'/dashboard/categorias', icono:'bi-tags'},
    {texto: 'Subcategorias', ruta:'/dashboard/subcategorias', icono:'bi-diagram-3'},
    {texto: 'Productos', ruta:'/dashboard/productos', icono:'bi-box-seam'}

];
// NO RECIBE props la lista de opcionesMenu esta definida aca mismo y no se necesita pasar nada desde el padre

function Sidebar() {
    return (
        <aside className="sidebar bg-dark text-light p-3" style={{width: 250, minHeight: '100vh'}}>
            <div className="d-flex align-items-center gap-2 mb-4 px-2">
                <i className="bi bi-boxes fs-4"></i>
                    <span className="fs-5 fw-semibold">inventario react</span>
            </div>
        
        <nav className="">


            {opcionesMenu.map((opcion)=>(  
                <NavLink
                    key={opcion.ruta} 
                    to={opcion.ruta}
                    end={opcion.fin}
                    className={({isActive}) => 'nav-link d-flex align-items-center gap-2 text-white ' + (isActive ? 'active bg-primary':'')}
                >
                    {/* end evita q /dashboard se marque activo cuando en realidad estamos en /dashboard/usuarios */}
                    {/* react-router-dom nos permite pasar una funcion al className que recibe isActive para saber su la ruta es la actual */}
                    <i className={`bi ${opcion.icono}`}></i>
                       <span>{opcion.texto}</span>
                </NavLink>
            ))
            }
        </nav>
        
        </aside>
        
    )
};

export default Sidebar;