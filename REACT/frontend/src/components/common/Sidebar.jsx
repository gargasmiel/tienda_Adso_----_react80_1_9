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
]