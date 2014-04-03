import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;

public class HelloServlet extends HttpServlet{
  @Override
  public void init(){
    System.out.printf("%s ¿Ã √ ±‚»≠ µ«æ˙Ω¿¥œ¥Ÿ.\n", getServletName());
  }
  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
    PrintWriter out = resp.getWriter();
    out.println("Hello World\n");
  }
  @Override
  public void destroy(){
    System.out.println("¿Ã¡® æ»≥Á»˜");
  }
  @Override
  public String getServletName(){
    return "æ»≥Á º≠∫Ì∏¥";
  }
}