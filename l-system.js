
function Vector2D(d0, d1) {
  this.d0 = d0;
  this.d1 = d1;
}

Vector2D.prototype.mul_scalar = function(s) {
  return new Vector2D(this.d0 * s, this.d1 * s);
}

Vector2D.prototype.add_vec = function(other) {
  return new Vector2D(
    this.d0 + other.d0, this.d1 + other.d1
  );
}

Vector2D.prototype.mul_vec = function(other) {
  return new Vector2D(
    this.d0 * other.d0, this.d1 * other.d1
  );
}

Vector2D.prototype.distance = function() {
  let _d0 = Math.pow(this.d0, 2);
  let _d1 = Math.pow(this.d1, 2);
  return Math.sqrt(_d0 + _d1);
}

Vector2D.prototype.normalized = function() {
  if ( this.distance() != 0.) {
    let _d0 = this.d0 / this.distance();
    let _d1 = this.d1 / this.distance();
    return new Vector2D(_d0, _d1);
  }
  return new Vector2D(this.d0, this.d1);
}

Vector2D.prototype.to = function(other) {
  this.d0 = other.d0;
  this.d1 = other.d1;
}

function set_viewbox(e, x_offset, y_offset) {
  let e_size = e.getBoundingClientRect();
  let view = - x_offset + " "
           + (- e_size.height - y_offset) + " "
           + (e_size.width    + 2 * x_offset) + " "
           + (e_size.height   + 2 * y_offset);
  e.setAttribute("viewBox", view);
}

function get_middle_x(e) {
  let e_size = e.getBoundingClientRect();
  return e_size.width / 2;
}

function get_middle(e) {
  let e_size = e.getBoundingClientRect();
  let x = parseFloat(e_size.width) / 2.;
  let y = parseFloat(e_size.height) / 2.;
  return new Vector2D(x, - y);
}

function draw_line(e, last, curr) {
  let line = document.createElementNS(
    'http://www.w3.org/2000/svg', 'line'
  );
  line.setAttribute('x1', curr.d0);
  line.setAttribute('y1', curr.d1);
  line.setAttribute('x2', last.d0);
  line.setAttribute('y2', last.d1);
  line.setAttribute('stroke', '#E8D7B9');

  e.appendChild(line);
}

// draw_grid {{{
function draw_grid(e, step) {
  let e_size = e.getBoundingClientRect();

  // vertical {{{
  for (let i = 0; i <= e_size.width; i += step) {
    let y_max    = - e_size.height;
    let new_line = '<line x1="' + i + '"'
                       + 'y1="0"'
                       + 'x2="' + i + '"'
                       + 'y2="' + y_max + '"'
                       + 'stroke="#333" />';

    e.innerHTML += new_line;
  }
  // }}}

  // horizontal {{{
  for (let i = 0; i >= - e_size.height; i -= step) {
    let new_line = '<line x1="0"'
                       + 'y1="' + i + '"'
                       + 'x2="' + e_size.width + '"'
                       + 'y2="' + i + '"'
                       + 'stroke="#333" />';

    e.innerHTML += new_line;
  }
  // }}}
}
// }}}

const CLOCKWISE        = '-';
const COUNTERCLOCKWISE = '+';
//const PITCHUP          = '&';
//const PITCHDOWN        = '^';
//const ROLLLEFT         = '\\';
//const ROLLRIGHT        = '/';
//const TURNAROUND       = 't';
const PUSH             = '[';
const POP              = ']';

// gen_string {{{
function gen_string(n, axiom, rules) {
  let res = axiom;

  for (let i = 0; i < n; i++) {
    axiom = res;
    res   = '';

    for (let j = 0; j < axiom.length; j++) {
      let c = axiom[j];
      if (rules[c] != null) {
        res += rules[c];
      } else {
        res += c
      }
    }
  }
  return res;
}
// }}}

function sleep(ms) {
  return new Promise(function(res) {
    setTimeout(res, ms)
  });
}

let resized = false;

async function l_system(
  n, angle, distance, axiom, rules, start, e
) {
  let s = gen_string(n, axiom, rules);

  let stack    = [];
  let curr     = start;
  let curr_rot = -90.;
  let last     = start;
  let forward  = new Vector2D(0.,1.);

  for (let i = 0; i < s.length; i++) {
    switch (s[i]) {
      case CLOCKWISE:
        curr_rot += angle;
        curr_rot = curr_rot % 360;
        break;
      case COUNTERCLOCKWISE:
        curr_rot -= angle;
        curr_rot = curr_rot % 360;
        break;
        case PUSH:
          let _c = new Vector2D(0.,0.);
          _c.to(curr);
          stack.push({pos:_c, rot: curr_rot});
        break;
      case POP:
        let _ = stack.pop();
        curr = _.pos;
        curr_rot = _.rot;
        break;
      default:

        last = curr;

        let x = angle_to_normal_vec(curr_rot);

        curr = curr.add_vec(x.mul_scalar(distance));

        await sleep(5);
        if(resized) return;
        draw_line(e, curr, last);
        break;
    }
  }
}

function angle_to_normal_vec(angle) {
  let angle_rad = angle * ( Math.PI / 180. );
  return new Vector2D(
    Math.cos(angle_rad), Math.sin(angle_rad)
  );
}

function fallback() {
  let svg = document.getElementById("fallback");
  let step = 200;
  let x_offset = 5;
  let y_offset = 5;

  let start_x = parseFloat(get_middle_x(svg));
  //let start = get_middle(svg);
  let start = new Vector2D(start_x, 0.);

  let axiom = 'F';
  let rules = {
    'F': 'FF-[-F+F+F]+[+F-F-F]'
  }

  set_viewbox(svg, x_offset, y_offset);
  //draw_grid(svg, step);

  l_system(4, 22.5, 8., axiom, rules, start, svg);

  window.onresize = async function() {
    svg.innerHTML = '';
    resized = true;
    await sleep(2000);
    svg.innerHTML = '';
    resized = false;
    set_viewbox(svg, x_offset, y_offset);
    start_x = parseFloat(get_middle_x(svg));
    start = new Vector2D(start_x, 0.);
    l_system(4, 25.7, 10., axiom, rules, start, svg);
    //draw_grid(svg, step);
  };
}
