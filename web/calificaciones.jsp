<%-- 
    Document   : calificaciones
    Created on : 08-mar-2019, 10:33:38
    Author     : Diurno
--%>

<%@page import="java.util.List"%>
<%@page import="entities.Punto"%>
<%@page import="entities.Playa"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<String> lista=(List<String>) request.getAttribute("lista");
    int vecesVotada;
%>
  
<table>
    <thead>
      <tr>
          <th>Carita</th>
          <th>Puntos</th>
      </tr>
    </thead>

    <tbody>
      <%for(int i=1;i<=5;i++){
          vecesVotada=0;
      %>
        <tr>
            <td><img class="caras" src="img/ic_<%=i%>.png"/></td>
            
            <%
                for(int y=0; y<lista.size() ;y++){
                    String puntuacion=lista.get(y).substring(0,lista.get(y).indexOf(" "));
                    if(i==Integer.parseInt(puntuacion)){
                        vecesVotada=Integer.parseInt(lista.get(y).substring(lista.get(y).indexOf(" ")+1));
                        break;
                    }
                }
            %>
            <td><%=vecesVotada%></td>
        </tr>
      <%}%>
    </tbody>
</table>

