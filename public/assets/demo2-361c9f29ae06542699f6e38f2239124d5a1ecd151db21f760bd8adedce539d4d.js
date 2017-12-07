(function() {
  var AreasBar,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  AreasBar = (function(superClass) {
    extend(AreasBar, superClass);

    function AreasBar() {
      return AreasBar.__super__.constructor.apply(this, arguments);
    }

    AreasBar.prototype.prepare_data = function() {
      return this.scourges = window.map_data.scourges;
    };

    AreasBar.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.draw_stitle();
      this.draw_infos();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_infos();
        };
      })(this));
    };

    AreasBar.prototype.draw_stitle = function() {
      var size;
      size = 24;
      this.svg.append('text').attr('x', 120).attr('y', size / 2 + 30).attr('dy', '.33em').text("原料产地自然灾害预警").style('font-size', size + 'px').style('fill', '#ffffff');
      if (this.scourges.length === 0) {
        return this.svg.append('text').attr('x', 140).attr('y', size / 2 + 30 + 40).attr('dy', '.33em').text("目前没有灾害预警信息").style('font-size', size + 'px').style('fill', '#ffffff');
      }
    };

    AreasBar.prototype.draw_infos = function() {
      var top;
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').style('transform', 'translate(-30px, 70px)');
      top = 0;
      return this.scourges.forEach((function(_this) {
        return function(x) {
          _this.draw_info(_this.panel, "images/scourges/" + x.icon + ".png", x.name, "近期" + x.scourge, x.date, top);
          return top += 40;
        };
      })(this));
    };

    AreasBar.prototype.draw_info = function(panel, img, city, weather, date, y) {
      var gap, img_width, left, left1, left2, left3, size;
      if (y == null) {
        y = 0;
      }
      size = 20;
      left = 70;
      img_width = 40;
      gap = size;
      panel.append('image').attr('x', left).attr('y', size / 2 + y).attr('xlink:href', img).attr('height', 40 + 'px').attr('width', img_width + 'px');
      left1 = left + img_width + gap;
      panel.append('text').attr('x', left1).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(city).style('font-size', size + 'px').style('fill', '#ffffff');
      left2 = left1 + size * 3 + gap;
      panel.append('text').attr('x', left2).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(weather).style('font-size', size + 'px').style('fill', '#f66');
      left3 = left2 + size * 4 + gap;
      return panel.append('text').attr('x', left3).attr('y', size / 2 + 20 + y).attr('dy', '.33em').text(date + ' 11:11').style('font-size', size + 'px').style('fill', '#ffde00');
    };

    return AreasBar;

  })(Graph);

  BaseTile.register('areas-bar', AreasBar);

}).call(this);
(function() {
  var LineChart,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChart = (function(superClass) {
    extend(LineChart, superClass);

    function LineChart() {
      this._curve = bind(this._curve, this);
      this._create_line = bind(this._create_line, this);
      return LineChart.__super__.constructor.apply(this, arguments);
    }

    LineChart.prototype.prepare_data = function() {
      this.materials = window.map_data.materials;
      if (this.idx == null) {
        this.idx = -1;
      }
      this.idx += 1;
      if (this.idx === this.materials.length) {
        this.idx = 0;
      }
      this.current_product = this.materials[this.idx];
      this.locality_1 = {
        name: this.current_product.locality_1,
        data: this.current_product.locality_1_data.slice(0, 12)
      };
      this.locality_2 = {
        name: this.current_product.locality_2,
        data: this.current_product.locality_2_data.slice(0, 12)
      };
      this.locality_3 = {
        name: this.current_product.locality_3,
        data: this.current_product.locality_3_data.slice(0, 12)
      };
      return this.locality_4 = {
        name: this.current_product.locality_4,
        data: this.current_product.locality_4_data.slice(0, 12)
      };
    };

    LineChart.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.h = this.height - 40;
      this.w = this.width - 60;
      this.gap = (this.w - 30) / 5;
      this.c1 = 'rgb(137, 189, 27)';
      this.c2 = 'rgb(6, 129, 200)';
      this.c3 = 'rgb(217, 6, 8)';
      this.c4 = 'rgb(255, 222, 0)';
      this.colors = [this.c1, this.c2, this.c3, this.c4];
      this.xscale = d3.scaleLinear().domain([0, 11]).range([0, this.w]);
      this.yscale = d3.scaleLinear().domain([0, 70]).range([this.h, 0]);
      this.make_defs();
      this.draw_axis();
      this.draw_lines();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_lines();
        };
      })(this));
    };

    LineChart.prototype.make_def = function(r, g, b, id) {
      var lg;
      lg = this.svg_defs.append('linearGradient').attr('id', id).attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.1)");
      return lg.append('stop').attr('offset', '100%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.0)");
    };

    LineChart.prototype.make_defs = function() {
      this.svg_defs = this.svg.append('defs');
      this.make_def(137, 189, 27, 'line-chart-linear1');
      this.make_def(6, 129, 200, 'line-chart-linear2');
      this.make_def(217, 6, 8, 'line-chart-linear3');
      return this.make_def(255, 222, 0, 'line-chart-linear4');
    };

    LineChart.prototype._create_line = function(data) {
      return d3.line().x((function(_this) {
        return function(d, idx) {
          if (idx === 0) {
            return _this.xscale(data.length - 1);
          } else if (idx === 1) {
            return _this.xscale(0);
          } else {
            return _this.xscale(idx - 2);
          }
        };
      })(this)).y((function(_this) {
        return function(d, idx) {
          return _this.yscale(d);
        };
      })(this));
    };

    LineChart.prototype.draw_lines = function() {
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').attr('transform', "translate(32, 10)");
      this.line1 = d3.line().x((function(_this) {
        return function(d, idx) {
          return _this.xscale(idx);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yscale(d);
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      this.panel.selectAll('path.pre-line').remove();
      this.panel.selectAll('circle').remove();
      this.cidx = 0;
      this._curve(this.locality_1.data);
      this._curve(this.locality_2.data);
      this._curve(this.locality_3.data);
      return this._curve(this.locality_4.data);
    };

    LineChart.prototype._curve = function(data) {
      var _data, arealine, color, d, fill, i, idx, len, results;
      if ((data != null) && data.length > 0) {
        color = this.colors[this.cidx];
        fill = "url(#line-chart-linear" + (this.cidx + 1) + ")";
        this.cidx += 1;
        arealine = this._create_line(data);
        _data = data.map(function(x) {
          return 0;
        });
        this.panel.append('path').datum([0, 0].concat(_data)).attr('class', 'pre-line').attr('d', arealine).style('fill', fill).datum([0, 0].concat(data)).transition().duration(1000).attr('d', arealine);
        this.panel.append('path').datum(_data).attr('class', 'pre-line').attr('d', this.line1).style('stroke', color).style('fill', 'transparent').style('stroke-width', 2).datum(data).transition().duration(1000).attr('d', this.line1);
        results = [];
        for (idx = i = 0, len = _data.length; i < len; idx = ++i) {
          d = _data[idx];
          results.push(this.panel.append('circle').attr('cx', this.xscale(idx)).attr('cy', this.yscale(d)).attr('r', 4).attr('fill', color).transition().duration(1000).attr('cy', this.yscale(data[idx])));
        }
        return results;
      }
    };

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy;
      axisx = this.svg.append('g').attr('class', 'axis axis-x white1').attr('transform', "translate(" + 32 + ", " + (10 + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y white1').attr('transform', "translate(" + 32 + ", " + 10 + ")");
      axisx.call(d3.axisBottom(this.xscale).tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).tickFormat(function(d, idx) {
        var m;
        m = idx + 1 + new Date().getMonth() + 1;
        if (m > 12) {
          m = m - 12;
        }
        return "" + m;
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 20, 40, 60, 80])).selectAll('.tick line').attr('x1', this.w);
    };

    return LineChart;

  })(Graph);

  BaseTile.register('line-chart', LineChart);

}).call(this);
(function() {
  var Material,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Material = (function(superClass) {
    extend(Material, superClass);

    function Material() {
      return Material.__super__.constructor.apply(this, arguments);
    }

    Material.prototype.prepare_data = function() {
      return this.materials = window.map_data.materials;
    };

    Material.prototype.draw = function() {
      console.log(1111111111);
      this.prepare_data();
      this.svg = this.draw_svg();
      this.idx = -1;
      this._draw();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this._draw();
        };
      })(this));
    };

    Material.prototype._draw = function() {
      this.idx += 1;
      if (this.idx === 3) {
        this.idx = 0;
      }
      this.current_product = this.materials[this.idx];
      this.draw_icon();
      return this.draw_texts();
    };

    Material.prototype.draw_icon = function() {
      if (this.flag != null) {
        this.flag.remove();
      }
      this.flag = this.svg.append('g').attr('class', 'flag');
      this.flag.append('circle').attr('r', this.height / 4).attr('cx', 80).attr('cy', this.height / 2).attr('fill', this.current_product.color).style('opacity', '0.5');
      return this.flag.append('image').attr('xlink:href', "images/materials/" + this.current_product.name + ".png").attr('height', this.height / 6 * 2).attr('width', this.height / 6 * 2).attr('x', 80 - this.height / 6).attr('y', this.height / 2 - this.height / 6);
    };

    Material.prototype.draw_texts = function() {
      var texts;
      this.svg.select('g.texts').remove();
      texts = this.svg.append('g').attr('class', 'texts').style('transform', 'translate(160px, 48px)');
      this.draw_text(texts, '即时采购价', this.current_product.current_now, 0, true);
      this.draw_text(texts, '去年同期价', this.current_product.current_history, 40);
      return this.draw_text(texts, '当前指导价', this.current_product.current_guiding, 80);
    };

    Material.prototype.draw_text = function(texts, label, number, y, flag) {
      var size, tn, tp;
      if (flag == null) {
        flag = false;
      }
      size = 20;
      texts.append('text').attr('x', 0).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text(label).style('font-size', size + 'px').style('fill', '#ffffff');
      tn = texts.append('text').attr('x', 110).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text(number).style('font-size', size + 'px').style('fill', '#ffde00');
      jQuery({
        n: 0
      }).animate({
        n: number
      }, {
        step: function(now) {
          return tn.text(~~(now * 1000) / 1000);
        }
      });
      texts.append('text').attr('x', 170).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text("万元 / 吨").style('font-size', size + 'px').style('fill', '#ffffff');
      if (flag) {
        tp = texts.append('text').attr('x', 270).attr('y', size / 2 + 10 + y).attr('dy', '.33em').text("2.34‰").style('font-size', size + 'px').style('fill', '#ffffff');
        jQuery({
          n: 0
        }).animate({
          n: this.current_product.percent_change
        }, {
          step: function(now) {
            return tp.text((~~(now * 100) / 100) + "‰");
          }
        });
        return texts.append('image').attr('x', 330).attr('y', size / 2 + 10 - size / 2 + y).attr('xlink:href', 'images/downicon1.png').attr('height', size).attr('width', size);
      }
    };

    return Material;

  })(Graph);

  BaseTile.register('material', Material);

}).call(this);
(function() {
  var CityAnimate, PathMap,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.prepare_data = function() {
      this.localities = window.map_data.localities;
      this.materials = window.map_data.materials;
      this.colors = {};
      this.materials.forEach((function(_this) {
        return function(x) {
          return _this.colors[x.name] = x.color;
        };
      })(this));
      return this.scourges = window.map_data.scourges;
    };

    PathMap.prototype.draw = function() {
      this.prepare_data();
      this.MAP_STROKE_COLOR = '#c8d8f1';
      this.MAP_FILL_COLOR = '#273957';
      this.svg = this.draw_svg();
      return this.load_data();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/china.json?1', (function(_this) {
        return function(error, _data) {
          _this.features = _data.features;
          _this.init();
          _this.idx = 0;
          _this.current_product = _this.materials[0];
          _this.draw_map();
          return jQuery(document).on('data-map:next-draw', function() {
            _this.prepare_data();
            return _this.draw_next();
          });
        };
      })(this));
    };

    PathMap.prototype.draw_next = function() {
      this.idx += 1;
      if (this.idx === this.materials.length) {
        this.idx = 0;
      }
      this.current_product = this.materials[this.idx];
      this._draw_texts();
      return this._draw_circle();
    };

    PathMap.prototype.init = function() {
      this.projection = d3.geoMercator().center([105, 28]).scale(this.width * 2.0).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.layer_map = this.svg.append('g');
      this.layer_circles = this.svg.append('g');
      return this.layer_icon = this.svg.append('g');
    };

    PathMap.prototype.draw_map = function() {
      this._draw_map();
      this._draw_texts();
      this._draw_circle();
      return this._draw_warning();
    };

    PathMap.prototype._draw_texts = function() {
      var _text, top;
      if (this.texts != null) {
        this.texts.remove();
      }
      this.texts = this.layer_map.append('g');
      _text = (function(_this) {
        return function(color, text, y, opacity) {
          var panel, size;
          panel = _this.texts.append('g').style('transform', "translate(50px, " + (_this.height - 150 + y) + "px)").style('opacity', opacity);
          size = 24;
          panel.append('circle').attr('cx', 8).attr('cy', 8).attr('r', 16).attr('fill', color);
          return panel.append('text').attr('x', 36).attr('y', size / 2 - 4).attr('dy', '.33em').text(text).style('font-size', size + 'px').style('fill', '#ffffff');
        };
      })(this);
      top = 0;
      return this.materials.forEach((function(_this) {
        return function(x) {
          _text(x.color, x.name + "原产地", top, _this.current_product.name === x.name ? 1 : 0.3);
          return top += 50;
        };
      })(this));
    };

    PathMap.prototype._draw_map = function() {
      if (this.areas != null) {
        this.areas.remove();
      }
      return this.areas = this.layer_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', this.MAP_STROKE_COLOR).style('stroke-width', 1).style('fill', this.MAP_FILL_COLOR);
    };

    PathMap.prototype._draw_circle = function() {
      var d, i, len, points, ref, ref1, results, x, y;
      if (this.points != null) {
        this.points.remove();
      }
      points = this.points = this.layer_map.append('g');
      ref = this.localities;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        d = ref[i];
        ref1 = this.projection([d.long, d.lat]), x = ref1[0], y = ref1[1];
        results.push(points.append('circle').attr('class', 'chandi').attr('cx', x).attr('cy', y).attr('r', d.amount).attr('fill', (function(_this) {
          return function() {
            return _this.colors[d.material];
          };
        })(this)).style('opacity', (function(_this) {
          return function() {
            if (d.material === _this.current_product.name) {
              return 1;
            } else {
              return 0.1;
            }
          };
        })(this)));
      }
      return results;
    };

    PathMap.prototype._draw_warning = function() {
      return this.scourges.forEach((function(_this) {
        return function(s) {
          var ref, x, y;
          ref = _this.projection([s.long, s.lat]), x = ref[0], y = ref[1];
          return new CityAnimate(_this, x, y, '#ffffff', 8, "images/scourges/" + s.icon + "-0.png", s.name + "：近期" + s.scourge).run();
        };
      })(this));
    };

    return PathMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(map, x1, y1, color1, width, img, text1) {
      this.map = map;
      this.x = x1;
      this.y = y1;
      this.color = color1;
      this.width = width;
      this.img = img;
      this.text = text1;
      this.layer_icon = this.map.layer_icon;
      this.layer_circles = this.map.layer_circles;
    }

    CityAnimate.prototype.run = function() {
      var size, w;
      w = 60;
      this.layer_icon.append('image').attr('xlink:href', this.img).attr('x', this.x).attr('y', this.y).style('transform', "translate(-" + (w / 2) + "px, -" + (w / 2) + "px)").attr('width', w).attr('height', w);
      size = 20;
      this.layer_icon.append('text').attr('x', this.x + 50).attr('y', this.y).attr('dy', '.33em').text(this.text).style('font-size', size + 'px').style('fill', '#fff').style('text-shadow', '0 0 3px rgba(0, 0, 0, 0.5)');
      return this.wave();
    };

    CityAnimate.prototype.wave = function() {
      this.circle_wave(0);
      return this.timer = setTimeout((function(_this) {
        return function() {
          return _this.wave();
        };
      })(this), 1500);
    };

    CityAnimate.prototype.stop = function() {
      return clearInterval(this.timer);
    };

    CityAnimate.prototype.circle_wave = function(delay) {
      var circle;
      circle = this.layer_circles.insert('circle', '.map-point').attr('cx', this.x).attr('cy', this.y).attr('stroke', this.color).attr('stroke-width', this.width).attr('fill', 'transparent');
      return jQuery({
        r: 10,
        o: 1,
        w: this.width
      }).delay(delay).animate({
        r: 100,
        o: 0.6,
        w: 0
      }, {
        step: function(now, fx) {
          if (fx.prop === 'r') {
            circle.attr('r', now);
          }
          if (fx.prop === 'o') {
            circle.style('opacity', now);
          }
          if (fx.prop === 'w') {
            return circle.attr('stroke-width', now);
          }
        },
        duration: 3000,
        easing: 'easeOutQuad',
        done: function() {
          return circle.remove();
        }
      });
    };

    return CityAnimate;

  })();

  BaseTile.register('path-map', PathMap);

}).call(this);
(function() {
  var LineChartTitle,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChartTitle = (function(superClass) {
    extend(LineChartTitle, superClass);

    function LineChartTitle() {
      return LineChartTitle.__super__.constructor.apply(this, arguments);
    }

    LineChartTitle.prototype.prepare_data = function() {
      this.materials = window.map_data.materials;
      if (this.idx == null) {
        this.idx = -1;
      }
      this.idx += 1;
      if (this.idx === this.materials.length) {
        this.idx = 0;
      }
      this.current_product = this.materials[this.idx];
      this.locality_1 = {
        name: this.current_product.locality_1,
        data: this.current_product.locality_1_data
      };
      this.locality_2 = {
        name: this.current_product.locality_2,
        data: this.current_product.locality_2_data
      };
      this.locality_3 = {
        name: this.current_product.locality_3,
        data: this.current_product.locality_3_data
      };
      return this.locality_4 = {
        name: this.current_product.locality_4,
        data: this.current_product.locality_4_data
      };
    };

    LineChartTitle.prototype.draw = function() {
      this.prepare_data();
      this.c1 = 'rgb(137, 189, 27)';
      this.c2 = 'rgb(6, 129, 200)';
      this.c3 = 'rgb(217, 6, 8)';
      this.c4 = 'rgb(255, 222, 0)';
      this.colors = [this.c1, this.c2, this.c3, this.c4];
      this.svg = this.draw_svg();
      this.draw_texts();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_texts();
        };
      })(this));
    };

    LineChartTitle.prototype.draw_texts = function() {
      var draw_locality, idx, left, size, y0, y1;
      if (this.texts != null) {
        this.texts.remove();
      }
      this.texts = this.svg.append('g').style('transform', 'translate(0px, 0px)');
      size = 20;
      this.texts.append('text').attr('x', 10).attr('y', this.height / 2 - 10).attr('dy', '.33em').text(this.current_product.name + "采购价格年度趋势（单位：万元 / 吨）").style('font-size', size + 'px').style('fill', '#ffffff');
      left = 32;
      y1 = this.height / 2 + 25;
      y0 = y1 - 7;
      idx = 0;
      draw_locality = (function(_this) {
        return function(locality) {
          var sz;
          if ((locality.data != null) && locality.data.length > 0) {
            _this.texts.append('rect').attr('x', left).attr('y', y0).attr('width', 24).attr('height', 12).style('fill', _this.colors[idx]);
            sz = size * 0.8;
            _this.texts.append('text').attr('x', left + 24 + 5).attr('y', y1).attr('dy', '.33em').text(locality.name).style('font-size', sz + 'px').style('fill', '#ffffff');
            left += 24 + sz * 5.5;
            return idx += 1;
          }
        };
      })(this);
      draw_locality(this.locality_1);
      draw_locality(this.locality_2);
      draw_locality(this.locality_3);
      return draw_locality(this.locality_4);
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);
(function() {
  var PageTitle,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  PageTitle = (function(superClass) {
    extend(PageTitle, superClass);

    function PageTitle() {
      return PageTitle.__super__.constructor.apply(this, arguments);
    }

    PageTitle.prototype.draw = function() {
      this.TEXT_SIZE = 50;
      this.svg = this.draw_svg();
      this.draw_title();
      return this.draw_points();
    };

    PageTitle.prototype.draw_title = function() {
      var title;
      return title = this.svg.append('text').attr('x', 70 + 30).attr('y', 10 + this.TEXT_SIZE / 2).attr('dy', '.33em').text('原材料产地监控').style('font-size', this.TEXT_SIZE + 'px').style('fill', '#aebbcb');
    };

    PageTitle.prototype.draw_points = function() {
      var points;
      return points = this.svg.append('image').attr('xlink:href', 'images/title-points.png').attr('width', this.TEXT_SIZE).attr('height', this.TEXT_SIZE).attr('x', 10).attr('y', 10).style('opacity', '0.5');
    };

    return PageTitle;

  })(Graph);

  BaseTile.register('title', PageTitle);

}).call(this);

window.data_path = '/demo2/data'
;
