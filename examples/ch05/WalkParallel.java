import java.util.concurrent.*;
public class WalkParallel{
  public static void main(String[] args){
    WalkParallel wp = new WalkParallel();
    System.out.println("������ - �̻�");
    wp.action(13);
  }
  private void action(int size){
    System.out.printf("%d���Ǿ��ذ����θ������Ͽ�.\n", size);
    System.out.printf("(�������ٸ�����������Ͽ�.)\n\n");
    ThreadPoolExecutor tpe = new ThreadPoolExecutor(10, 20, 60, TimeUnit.SECONDS, new SynchronousQueue<Runnable>());
    for(int i=0; i<size; i++){
      tpe.execute(new People(i+1));
    }
    tpe.shutdown();
  }
  class People implements Runnable{
    private int index;
    private Object lock = new Object();
    public People(int index){
      this.index = index;
    }
    public void run(){
      synchronized(lock){
        try{
          lock.wait(1000L);
        }catch(InterruptedException e){
        }
        System.out.printf("��%d�Ǿ��ذ������ٰ�׸���.\n", index);
      }
    }
  }
}
