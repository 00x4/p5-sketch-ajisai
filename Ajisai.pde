static final int PANEL_MAX = 200;
java.util.List<Panel> _panels;
boolean _stop;
boolean _ellipse;

void setup() {
  size(400, 300);
  smooth();
  _panels = new java.util.LinkedList<Panel>();
}

void draw() {
  background(255);
  drawPanels();
  addPanel();
  delay(10);
  //saveFrame("_frames/######.png");
}

class Pos {
  public Pos() {
  }

  public Pos(Pos other) {
    x = other.x;
    y = other.y;
  }

  public Pos(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float x;
  float y;
}

class Panel {
  public Panel(Pos pos, float size) {
    _pos = pos;
    _size = size;
  }

  private Pos _pos = new Pos();
  private float _size;
  private Pos _direction = new Pos();
  private color _bg = 255;
  private color _border = 220;

  void flick() {
    _direction.x = random(-20, 20);
    _direction.y = random(-20, 20);
  }

  void move() {
    if (_direction.x == 0 && _direction.y == 0) {
      return;
    }
    _pos.x += _direction.x;
    _pos.y += _direction.y;
    _direction.x /= 2;
    _direction.y /= 2;
    if (-1 < _direction.x && _direction.x < 1) {
      _direction.x = 0;
    }
    if (-1 < _direction.y && _direction.y < 1) {
      _direction.y = 0;
    }
  }

  void draw(PApplet app, boolean elliptic) {
    app.fill(_bg);
    app.stroke(_border);
    if (elliptic) {
      app.ellipse(_pos.x + _size / 2, _pos.y + _size / 2,
        _size * 1.2, _size * 1.2);
    }
    else {
      app.rect(_pos.x, _pos.y, _size, _size);
    }
  }

  void setColors(color bg, color border) {
    _bg = bg;
    _border = border;
  }
}

Panel createWhitePanel(Pos pos, float size) {
  return new Panel(pos, size);
}

Panel createPanel(Pos pos, color bg, color border, float size) {
  Panel p = new Panel(pos, size);
  p.setColors(bg, border);
  return p;
}

void drawPanels() {
  for (Panel p : _panels) {
    p.move();
    p.draw(this, _ellipse);
  }
}

void addPanel() {
  // remove old panels
  while (_panels.size() > PANEL_MAX) {
    _panels.remove(0);
  }
  if (!_stop) {
    // add blue panels
    _panels.add(createPanel(new Pos(random(width), random(height)),
      color(random(100, 150), random(100, 150), random(150, 200), 50),
      color(255, 0), 50
    ));
    // add white panels
    _panels.add(createWhitePanel(
      new Pos(random(width), random(height)), random(20, 30)));
  }
}

void flickAll() {
  for (Panel p : _panels) {
    p.flick();
  }
}

void mousePressed() {
  flickAll();
}

void keyPressed() {
  if (key == ' ') {
    _stop = !_stop;
  }
  if (key == '0') {
    _panels.clear();
  }
  if (keyCode == TAB) {
    _ellipse = !_ellipse;
  }
}
