import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Aoc24b {

  private Map<Integer, List<Component>> components = new HashMap<>();

  public Aoc24b() throws IOException {
    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    String line;
    while ((line = reader.readLine()) != null) {
      Component component = new Component(line);
      getList(component.a).add(component);
      getList(component.b).add(component);
    }
  }
   
  public void run() {
    Metrics max = computeMax(0);
    System.out.println(max.strength);
  }

  private Metrics computeMax(int startNumPorts) {
    Metrics max = new Metrics();
    for (Component c : getList(startNumPorts)) {
      if (!c.used) {
        c.used = true;
        max = Metrics.max(max, computeMax(c.otherSide(startNumPorts)).add(1, c.strength));
        c.used = false;
      }
    }
    return max;
  }

  private List<Component> getList(int numPorts) {
    if (!components.containsKey(numPorts)) {
      components.put(numPorts, new ArrayList<Component>());
    }
    return components.get(numPorts);
  }

  public static void main(String[] args) throws IOException {
    new Aoc24b().run();
  }
}

class Metrics {
  public final int length;
  public final int strength;

  public Metrics() {
    length = 0;
    strength = 0;
  }

  public Metrics(int length, int strength) {
    this.length = length;
    this.strength = strength;
  }

  public Metrics add(int length, int strength) {
    return new Metrics(this.length + length, this.strength + strength);
  }

  public static Metrics max(Metrics a, Metrics b) {
    if (a.length > b.length) return a;
    if (b.length > a.length) return b;
    if (a.strength > b.strength) return a;
    if (b.strength > a.strength) return b;
    return a;
  }
}

class Component {

  public final int a;
  public final int b;
  public final int strength;

  public boolean used;

  public Component(String line) {
    String[] parts = line.split("/");
    a = Integer.parseInt(parts[0]);
    b = Integer.parseInt(parts[1]);
    strength = a + b;
  }

  private Component(int a, int b) {
    this.a = a;
    this.b = b;
    strength = a + b;
  }

  public int otherSide(int numPorts) {
    return a == numPorts ? b : a;
  }
}
