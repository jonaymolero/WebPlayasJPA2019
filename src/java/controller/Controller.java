/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import entities.Ccaa;
import entities.Municipio;
import entities.Playa;
import entities.Provincia;
import entities.Punto;
import entities.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jpautil.JPAUtil;

/**
 *
 * @author Diurno
 */
@WebServlet(name = "Controller", urlPatterns = {"/Controller"})
public class Controller extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher;
        
        String op;
        String sql;
        Query query;
        EntityManager em = null;
        Usuario user=null;
        EntityTransaction transaction;
        String mensaje;
        
        if (em == null) {
            em = JPAUtil.getEntityManagerFactory().createEntityManager();
            session.setAttribute("em", em);
        }
        
        op = request.getParameter("op");
        
        if (op.equals("inicio")) {
            query=em.createNamedQuery("Ccaa.findAll");
            List<Ccaa> listaComunidades=query.getResultList();
            
            session.setAttribute("listaComunidades",listaComunidades);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("comunidad")){
            Ccaa comunidadSeleccionada=em.find(Ccaa.class, Short.parseShort(request.getParameter("selectComunidad")));
            
            session.removeAttribute("listaProvincias");
            session.removeAttribute("listaMunicipios");
            session.removeAttribute("comboMunicipios");
            session.removeAttribute("comboProvincias");
            session.removeAttribute("listaPlayas");
            session.setAttribute("listaProvincias",comunidadSeleccionada.getProvinciaList());
            session.setAttribute("comboComunidad", request.getParameter("selectComunidad"));
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("provincia")){
            Provincia provinciaSeleccionada=em.find(Provincia.class, Short.parseShort(request.getParameter("selectProvincia")));
            
            session.removeAttribute("listaMunicipios");
            session.removeAttribute("comboMunicipios");
            session.removeAttribute("listaPlayas");
            session.setAttribute("listaMunicipios",provinciaSeleccionada.getMunicipioList());
            session.setAttribute("comboProvincias", request.getParameter("selectProvincia"));
           
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("municipio")){
            Municipio municipioSeleccionado=em.find(Municipio.class, Integer.parseInt(request.getParameter("selectMunicipio")));
            
            session.setAttribute("listaPlayas",municipioSeleccionado.getPlayaList());
            session.setAttribute("comboMunicipios", request.getParameter("selectMunicipio"));
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("info")){
            Playa playa=em.find(Playa.class, Integer.parseInt(request.getParameter("id")));
            request.setAttribute("playaSeleccionada", playa);
            
            dispatcher = request.getRequestDispatcher("playa.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("infoPlayas")){
            Playa playa=em.find(Playa.class, Integer.parseInt(request.getParameter("idplaya")));
            
            sql = "select concat(p.puntos,' ',count(p.puntos)) from Punto p where p.playa.id = :idplaya group by p.puntos order by p.puntos"; 
            query = em.createQuery(sql);
            query.setParameter("idplaya", playa.getId());
            List<String> lista=query.getResultList();
            
           
            request.setAttribute("lista", lista);
            
            dispatcher = request.getRequestDispatcher("calificaciones.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("login")){
            String nick=request.getParameter("nick");
            String pass=request.getParameter("pass");
            query=em.createNamedQuery("Usuario.findByNickByPass");
            query.setParameter("pass", pass);
            query.setParameter("nick", nick);
            
            try{
                user=(Usuario) query.getSingleResult();
            }catch(Exception e){
                
            }

            if(user!=null){
                
                session.setAttribute("usuario", user);
                mensaje="Bienvenido "+user.getNick();
                
            }else{
                query=em.createNamedQuery("Usuario.findByNick");
                query.setParameter("nick", nick);
                try{
                    user=(Usuario) query.getSingleResult();
                }catch(Exception e){

                }
                
                if(user==null){
                    user=new Usuario(Short.parseShort("1"));
                    user.setNick(nick);
                    user.setPass(pass);

                    transaction = em.getTransaction();
                    transaction.begin();
                    em.persist(user);
                    transaction.commit();
                    
                    query=em.createNamedQuery("Usuario.findByNick");
                    query.setParameter("nick", nick);
                    user=(Usuario) query.getSingleResult();
                    
                    mensaje="Registrado correctamente";
                    session.setAttribute("usuario", user);
                }else{
                    mensaje="Contraseña incorrecta";
                }
            }
            
            request.setAttribute("mensaje", mensaje);
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("voto")){
            Usuario userActual=(Usuario) session.getAttribute("usuario");
            Playa playa=em.find(Playa.class, Integer.parseInt(request.getParameter("playaid")));
            Punto puntos=new Punto(1);
            puntos.setUsuario(userActual);
            puntos.setPlaya(playa);
            puntos.setPuntos(Short.parseShort(request.getParameter("rating")));
            
            try{
                transaction = em.getTransaction();
                transaction.begin();
                em.persist(puntos);
                transaction.commit();
                mensaje=puntos.getPuntos()+" punto/s añadidos correctamente a "+playa.getNombre();
            }catch(Exception e){
                mensaje="Error al enviar los puntos";
            }
            
            request.setAttribute("mensaje", mensaje);
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }else if(op.equals("logout")){
            session.setAttribute("usuario", null);
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
