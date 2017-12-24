import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Aoc24a {

  private Map<Integer, List<Component>> components = new HashMap<>();

  public Aoc24a() throws IOException {
    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    String line;
    while ((line = reader.readLine()) != null) {
      Component component = new Component(line);
      getList(component.a).add(component);
      getList(component.b).add(component);
    }
  }
   
  public void run() {
    int maxStrength = computeMaxStrength(0);
    System.out.println(maxStrength);
  }

  private int computeMaxStrength(int startNumPorts) {
    int maxStrength = 0;
    for (Component c : getList(startNumPorts)) {
      if (!c.used) {
        c.used = true;
        maxStrength = Math.max(maxStrength, c.strength + computeMaxStrength(c.otherSide(startNumPorts)));
        c.used = false;
      }
    }
    return maxStrength;
  }

  private List<Component> getList(int numPorts) {
    if (!components.containsKey(numPorts)) {
      components.put(numPorts, new ArrayList<Component>());
    }
    return components.get(numPorts);
  }

  public static void main(String[] args) throws IOException {
    new Aoc24a().run();
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
