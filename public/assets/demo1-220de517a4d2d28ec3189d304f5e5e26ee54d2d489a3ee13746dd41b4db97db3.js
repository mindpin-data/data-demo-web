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
      var countries, top;
      countries = window.map_data.countries;
      top = (countries.sort(function(a, b) {
        return b.total - a.total;
      })).slice(0, 6);
      this.topmax = top[0].total;
      this.farr = top.map(function(x) {
        return x.code;
      });
      this.amounts = top.map(function(x) {
        return x.total;
      });
      return this.names = top.map(function(x) {
        return x.name;
      });
    };

    AreasBar.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.make_defs();
      this.draw_flags();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_flags();
        };
      })(this));
    };

    AreasBar.prototype.make_defs = function() {
      var defs, lg;
      defs = this.svg.append('defs');
      lg = defs.append('linearGradient').attr('id', 'areas-bar-linear').attr('x1', '0%').attr('y1', '0%').attr('x2', '100%').attr('y2', '0%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', '#7184a3');
      return lg.append('stop').attr('offset', '100%').attr('stop-color', '#f9f9f7');
    };

    AreasBar.prototype.draw_flags = function() {
      var f, h, i, idx, len, max, ref, results, w;
      if (this.flags) {
        this.flags.remove();
      }
      this.flags = this.svg.append('g');
      max = this.topmax;
      h = this.height / 5;
      w = this.width * 0.8 - 100;
      ref = this.farr;
      results = [];
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        f = ref[idx];
        results.push(this.draw_flag(this.flags, f, h, w, idx, this.amounts, max, this.names));
      }
      return results;
    };

    AreasBar.prototype.draw_flag = function(flags, f, h, w, idx, amounts, max, names) {
      var amount, bar, bh, bw, flag, offl, text, text1, th, th1;
      flag = flags.append('image').attr('xlink:href', "images/countries/" + f + ".png").attr('height', h - 30).attr('width', (h - 30) / 2 * 3).attr('x', 0).attr('y', h * idx + 30);
      offl = 80;
      amount = amounts[idx];
      bh = h - 30;
      bw = w * (amount / max) + 80;
      bar = flags.append('rect').attr('fill', 'url(#areas-bar-linear)').attr('width', bw).attr('height', bh).attr('x', offl).attr('y', h * idx + 30);
      th = 24;
      text = flags.append('text').attr('fill', '#011224').attr('x', offl + 5).attr('y', h * idx + 30 + bh / 2).attr('dy', '.33em').style('font-size', th + 'px').text(names[idx]);
      th1 = 30;
      text1 = flags.append('text').attr('fill', '#011224').attr('text-anchor', 'end').attr('x', offl + bw - 5).attr('y', h * idx + 30 + bh / 2).attr('dy', '.33em').style('font-size', th1 + 'px').style('font-weight', 'bold').text(amount);
      jQuery({
        w: 100
      }).animate({
        w: bw
      }, {
        step: function(now) {
          bar.attr('width', now);
          return text1.attr('x', offl + now - 5);
        },
        duration: 1000
      });
      return jQuery({
        a: 0
      }).animate({
        a: amount
      }, {
        step: function(now) {
          return text1.text(Math.floor(now));
        },
        duration: 1000
      });
    };

    return AreasBar;

  })(Graph);

  BaseTile.register('areas-bar', AreasBar);

}).call(this);
(function() {
  var LineChart,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChart = (function(superClass) {
    extend(LineChart, superClass);

    function LineChart() {
      return LineChart.__super__.constructor.apply(this, arguments);
    }

    LineChart.prototype.prepare_data = function() {
      var countries;
      countries = window.map_data.countries;
      if (this.aidx == null) {
        this.aidx = 0;
      }
      this.aidx += 1;
      if (this.aidx === countries.length) {
        this.aidx = 0;
      }
      this.current_area = countries[this.aidx];
      this.data0 = this.current_area.now;
      return this.data1 = this.current_area.history;
    };

    LineChart.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.h = this.height - 40;
      this.w = this.width - 60;
      this.gap = (this.w - 30) / 5;
      this.c1 = 'rgb(205, 255, 65)';
      this.c2 = 'rgb(60, 180, 236)';
      this.xscale = d3.scaleLinear().domain([0, 5]).range([0, this.w]);
      this.yscale = d3.scaleLinear().domain([0, 200]).range([this.h, 0]);
      this.make_defs();
      this.draw_axis();
      this.draw_lines();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.next_draw();
        };
      })(this));
    };

    LineChart.prototype.next_draw = function() {
      this.prepare_data();
      return this.draw_lines();
    };

    LineChart.prototype.make_def = function(r, g, b, id) {
      this._lg = this.svg_defs.append('linearGradient').attr('id', id).attr('x1', '0%').attr('y1', '0%').attr('x2', '0%').attr('y2', '100%');
      this._lg.append('stop').attr('offset', '0%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.2)");
      return this._lg.append('stop').attr('offset', '100%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.0)");
    };

    LineChart.prototype.make_defs = function() {
      this.svg_defs = this.svg.append('defs');
      this.make_def(205, 255, 65, 'line-chart-linear1');
      return this.make_def(60, 180, 236, 'line-chart-linear2');
    };

    LineChart.prototype.draw_lines = function() {
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').attr('transform', "translate(42, 10)");
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
      this._draw(this._create_line(this.data0), this.line1, this.data0, this.c1, 'url(#line-chart-linear1)');
      return this._draw(this._create_line(this.data1), this.line1, this.data1, this.c2, 'url(#line-chart-linear2)');
    };

    LineChart.prototype._draw = function(arealine, line, data, color, fill) {
      var _data, duration;
      _data = data.map(function(x) {
        return 0;
      });
      duration = 1000;
      this.panel.append('path').datum([0, 0].concat(_data)).attr('class', 'pre-line').attr('d', arealine).style('fill', fill).datum([0, 0].concat(data)).transition().attr('d', arealine).duration(duration).ease(d3.easeCubicOut);
      this.panel.append('path').datum(_data).attr('class', 'pre-line').attr('d', line).style('stroke', color).style('fill', 'transparent').style('stroke-width', 2).datum(data).transition().attr('d', line).duration(duration).ease(d3.easeCubicOut);
      return _data.forEach((function(_this) {
        return function(d, idx) {
          return _this.panel.append('circle').attr('cx', _this.xscale(idx)).attr('cy', _this.yscale(d)).attr('r', 4).attr('fill', color).transition().attr('cy', _this.yscale(data[idx])).duration(duration).ease(d3.easeCubicOut);
        };
      })(this));
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

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy;
      axisx = this.svg.append('g').attr('class', 'axis axis-x white1').attr('transform', "translate(" + 42 + ", " + (10 + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y white1').attr('transform', "translate(" + 42 + ", " + 10 + ")");
      axisx.call(d3.axisBottom(this.xscale).tickValues([0, 1, 2, 3, 4, 5]).tickFormat(function(d, idx) {
        if (idx === 0) {
          return '';
        }
        return "" + (idx * 2);
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 50, 100, 150, 200])).selectAll('.tick line').attr('x1', this.w);
    };

    return LineChart;

  })(Graph);

  BaseTile.register('line-chart', LineChart);

}).call(this);
(function() {
  var OneArea,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  OneArea = (function(superClass) {
    extend(OneArea, superClass);

    function OneArea() {
      return OneArea.__super__.constructor.apply(this, arguments);
    }

    OneArea.prototype.prepare_data = function() {
      this.AREA_DATA = {};
      window.map_data.countries.forEach((function(_this) {
        return function(x) {
          return _this.AREA_DATA[x.code] = {
            n: x.name,
            d: x.total,
            p: x.percent_change
          };
        };
      })(this));
      return this.TOGGLE_AREAS = window.map_data.countries.map(function(x) {
        return x.code;
      });
    };

    OneArea.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.current_area = this.TOGGLE_AREAS[0];
      this.draw_flag();
      this.draw_texts();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.next_draw();
        };
      })(this));
    };

    OneArea.prototype.next_draw = function() {
      this.prepare_data();
      if (this.aidx == null) {
        this.aidx = 0;
      }
      this.aidx += 1;
      if (this.aidx === this.TOGGLE_AREAS.length) {
        this.aidx = 0;
      }
      this.current_area = this.TOGGLE_AREAS[this.aidx];
      this.draw_flag();
      return this.draw_texts();
    };

    OneArea.prototype.draw_flag = function() {
      if (this.flag != null) {
        this.flag.remove();
      }
      this.flag = this.svg.append('g').attr('class', 'flag');
      return this.flag.append('image').attr('xlink:href', "images/countries/" + this.current_area + ".png").attr('height', this.height - 60).attr('width', (this.height - 60) / 2 * 3).attr('x', 0).attr('y', 30);
    };

    OneArea.prototype.draw_texts = function() {
      var number, percent, size, size1, size2, texts;
      if (this.texts != null) {
        this.texts.remove();
      }
      this.texts = texts = this.svg.append('g').attr('class', 'texts').style('transform', 'translate(210px, 0px)');
      size = 30;
      texts.append('text').attr('x', 0).attr('y', size / 2 + 20).attr('dy', '.33em').text(this.AREA_DATA[this.current_area].n + "销量").style('font-size', size + 'px').style('fill', '#ffffff');
      size1 = 40;
      number = texts.append('text').attr('x', 0).attr('y', size / 2 + 20 + 50).attr('dy', '.33em').text(0).style('font-size', size1 + 'px').style('fill', '#ffde00');
      jQuery({
        d: 0
      }).animate({
        d: this.AREA_DATA[this.current_area].d
      }, {
        step: function(now) {
          return number.text(Math.floor(now));
        },
        duration: 1000
      });
      size2 = 30;
      percent = texts.append('text').attr('x', 0).attr('y', size / 2 + 20 + 50 + 50).attr('dy', '.33em').text("同比 " + 0.0 + "%").style('font-size', size2 + 'px').style('fill', '#ffffff');
      jQuery({
        p: 0
      }).animate({
        p: this.AREA_DATA[this.current_area].p
      }, {
        step: function(now) {
          var t;
          t = Math.floor(now * 10) / 10;
          if (t === ~~t) {
            t = t + ".0";
          }
          return percent.text("同比 " + t + "%");
        },
        duration: 1000
      });
      return texts.append('image').attr('x', 160).attr('y', size / 2 + 20 + 50 + 50 - 15).attr('xlink:href', 'images/upicon1.png').attr('height', size2).attr('width', size2);
    };

    return OneArea;

  })(Graph);

  BaseTile.register('one-area', OneArea);

}).call(this);
(function() {
  var CityAnimate, PathMap, YDYL_AREAS, YDYL_CITIES_NORTH, YDYL_CITIES_SOUTH,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  YDYL_AREAS = ['CHN', 'RUS', 'MNG', 'IDN', 'THA', 'MYS', 'VNM', 'SGP', 'PHL', 'MMR', 'KHM', 'LAO', 'BRN', 'TLS', 'IND', 'PAK', 'BGD', 'LKA', 'AFG', 'NPL', 'MDV', 'BTN', 'SAU', 'ARE', 'OMN', 'IRN', 'TUR', 'ISR', 'EGY', 'KWT', 'IRQ', 'QAT', 'JOR', 'LBN', 'BHR', 'YEM', 'SYR', 'PSE', 'POL', 'ROU', 'CZE', 'SVK', 'BGR', 'HUN', 'LVA', 'LTU', 'SVN', 'EST', 'HRV', 'ALB', 'SRB', 'MKD', 'BIH', 'MNE', 'KAZ', 'UZB', 'TKM', 'KGZ', 'TJK', 'UKR', 'BLR', 'GEO', 'AZE', 'ARM', 'MDA', 'KEN'];

  YDYL_CITIES_NORTH = [
    {
      c: '西安',
      lat: 34.34,
      long: 108.94
    }, {
      c: '兰州',
      lat: 36.07,
      long: 103.84
    }, {
      c: '乌鲁木齐',
      lat: 43.83,
      long: 87.62
    }, {
      c: '霍尔果斯',
      lat: 44.21,
      long: 80.42
    }, {
      c: '阿拉木图',
      lat: 43.24,
      long: 76.91
    }, {
      c: '比什凯克',
      lat: 42.87,
      long: 74.59
    }, {
      c: '杜尚别',
      lat: 38.5,
      long: 68.9
    }, {
      c: '德黑兰',
      lat: 35.8,
      long: 51.0
    }, {
      c: '伊斯坦布尔',
      lat: 41.0,
      long: 28.9
    }, {
      c: '莫斯科',
      lat: 55.8,
      long: 37.6
    }, {
      c: '杜伊斯堡',
      lat: 51.5,
      long: 6.8
    }, {
      c: '鹿特丹',
      lat: 51.9,
      long: 4.5
    }
  ];

  YDYL_CITIES_SOUTH = [
    {
      c: '福州',
      lat: 26.0,
      long: 119.0
    }, {
      c: '泉州',
      lat: 24.9,
      long: 118.6
    }, {
      c: '广州',
      lat: 23.0,
      long: 113.0
    }, {
      c: '湛江',
      lat: 21.2,
      long: 110.3
    }, {
      c: '海口',
      lat: 20.02,
      long: 110.35
    }, {
      c: '北海',
      lat: 21.49,
      long: 109.12
    }, {
      c: '河内',
      lat: 21.0,
      long: 105.9
    }, {
      c: '吉隆坡',
      lat: 3.0,
      long: 101.8
    }, {
      c: '雅加达',
      lat: -6.0,
      long: 106.9
    }, {
      c: '科伦坡',
      lat: 6.9,
      long: 79.9
    }, {
      c: '加尔各答',
      lat: 22.5,
      long: 88.0
    }, {
      c: '内罗毕',
      lat: 1.3,
      long: 36.8
    }, {
      c: '雅典',
      lat: 38.0,
      long: 23.8
    }, {
      c: '威尼斯',
      lat: 45.5,
      long: 12.0
    }
  ];

  PathMap = (function(superClass) {
    extend(PathMap, superClass);

    function PathMap() {
      this._draw_curve = bind(this._draw_curve, this);
      this._draw_city = bind(this._draw_city, this);
      return PathMap.__super__.constructor.apply(this, arguments);
    }

    PathMap.prototype.prepare_data = function() {
      return this.TOGGLE_AREAS = window.map_data.countries.map(function(x) {
        return x.code;
      });
    };

    PathMap.prototype.draw = function() {
      this.prepare_data();
      this.MAP_STROKE_COLOR = '#021225';
      this.MAP_FILL_COLOR = '#273957';
      this.MAP_FILL_COLOR_YDYL = '#6a95dd';
      this.MAP_FILL_COLOR_CN = this.MAP_FILL_COLOR_YDYL;
      this.MAP_FILL_COLOR_CURRENT = '#ffae00';
      this.svg = this.draw_svg();
      this.areas = YDYL_AREAS;
      this.current_area = 'THA';
      this.main_area = 'CHN';
      return this.load_data();
    };

    PathMap.prototype.load_data = function() {
      return d3.json('data/world-countries.json?1', (function(_this) {
        return function(error, _data) {
          var area, code, ydyls;
          _this.features = _data.features;
          ydyls = (function() {
            var i, len, ref, results;
            ref = this.areas;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              code = ref[i];
              area = this.features.filter(function(x) {
                return x.id === code;
              })[0];
              if (area != null) {
                results.push(area.id);
              } else {
                results.push(void 0);
              }
            }
            return results;
          }).call(_this);
          _this.init();
          _this.draw_map();
          _this.draw_cities();
          _this.draw_ydyl_curve();
          return _this.draw_current_city();
        };
      })(this));
    };

    PathMap.prototype.init = function() {
      this.projection = d3.geoMercator().center([68, 30]).scale(this.width * 0.42).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.g_layer_map = this.svg.append('g');
      this.g_layer_curve = this.svg.append('g');
      this.g_layer_circles = this.svg.append('g');
      this.g_layer_map_point = this.svg.append('g');
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          return _this.next_draw();
        };
      })(this));
    };

    PathMap.prototype.next_draw = function() {
      this.prepare_data();
      if (this.aidx == null) {
        this.aidx = 0;
      }
      this.aidx += 1;
      if (this.aidx === this.TOGGLE_AREAS.length) {
        this.aidx = 0;
      }
      this.current_area = this.TOGGLE_AREAS[this.aidx];
      this.draw_map();
      return this.draw_current_city();
    };

    PathMap.prototype.draw_map = function() {
      if (this.countries != null) {
        this.countries.remove();
      }
      return this.countries = this.g_layer_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).attr('stroke', this.MAP_STROKE_COLOR).attr('stroke-width', 1).attr('fill', (function(_this) {
        return function(d) {
          if (d.id === _this.main_area) {
            return _this.MAP_FILL_COLOR_CN;
          }
          if (d.id === _this.current_area) {
            return _this.MAP_FILL_COLOR_CURRENT;
          }
          if (_this.areas.indexOf(d.id) > -1) {
            return _this.MAP_FILL_COLOR_YDYL;
          }
          return _this.MAP_FILL_COLOR;
        };
      })(this));
    };

    PathMap.prototype.draw_current_city = function() {
      var feature, ref, ref1, ref2, ref3, x, y;
      feature = this.features.filter((function(_this) {
        return function(x) {
          return x.id === _this.current_area;
        };
      })(this))[0];
      if (feature != null) {
        if (this.current_area === 'MYS') {
          ref = this.projection([101.8, 3.0]), x = ref[0], y = ref[1];
        } else if (this.current_area === 'IDN') {
          ref1 = this.projection([106.9, -6.0]), x = ref1[0], y = ref1[1];
        } else if (this.current_area === 'VNM') {
          ref2 = this.projection([105.9, 21.0]), x = ref2[0], y = ref2[1];
        } else {
          ref3 = this.path.centroid(feature), x = ref3[0], y = ref3[1];
        }
        this._draw_map_point(x, y);
        return new CityAnimate(this.g_layer_circles, x, y, 'rgb(243, 147, 16)', 8).run();
      }
    };

    PathMap.prototype._draw_map_point = function(x, y) {
      this.g_layer_map_point.selectAll('image').remove();
      return this.g_layer_map_point.append('image').attr('class', 'map-point').attr('xlink:href', 'images/mapicon.png').attr('x', x).attr('y', y).style('transform', 'translate(-30px, -50px)').attr('width', 60).attr('height', 60);
    };

    PathMap.prototype.draw_cities = function() {
      var city, i, j, len, len1, ref, ref1, results;
      for (i = 0, len = YDYL_CITIES_NORTH.length; i < len; i++) {
        city = YDYL_CITIES_NORTH[i];
        ref = this.projection([city.long, city.lat]), city.x = ref[0], city.y = ref[1];
        this._draw_city(city);
      }
      results = [];
      for (j = 0, len1 = YDYL_CITIES_SOUTH.length; j < len1; j++) {
        city = YDYL_CITIES_SOUTH[j];
        ref1 = this.projection([city.long, city.lat]), city.x = ref1[0], city.y = ref1[1];
        results.push(this._draw_city(city));
      }
      return results;
    };

    PathMap.prototype._draw_city = function(city) {
      var ani, circle;
      circle = this.g_layer_curve.append('circle').attr('class', 'runnin').attr('cx', city.x).attr('cy', city.y).attr('r', 4).attr('fill', '#34cee9');
      ani = function() {
        return jQuery({
          r: 4,
          o: 1
        }).animate({
          r: 12,
          o: 0.5
        }, {
          step: function(now, fx) {
            if (fx.prop === 'r') {
              circle.attr('r', now);
            }
            if (fx.prop === 'o') {
              return circle.style('opacity', now);
            }
          },
          duration: 1500,
          done: function() {
            return ani();
          }
        });
      };
      return ani();
    };

    PathMap.prototype.draw_ydyl_curve = function() {
      this.line1 = d3.line().x((function(_this) {
        return function(d) {
          return d.x;
        };
      })(this)).y((function(_this) {
        return function(d) {
          return d.y;
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      this._draw_curve(this.line1, YDYL_CITIES_NORTH, '#cdff41');
      return this._draw_curve(this.line1, YDYL_CITIES_SOUTH, '#ff7c41');
    };

    PathMap.prototype._draw_curve = function(line, cities, color) {
      return this.g_layer_curve.append('path').attr('class', 'running').datum(cities).attr('d', line).style('stroke', color).style('fill', 'transparent').style('stroke-width', 4).style('stroke-dasharray', '5 10').style('stroke-linecap', 'round');
    };

    return PathMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(layer, x1, y1, color1, width, img) {
      this.layer = layer;
      this.x = x1;
      this.y = y1;
      this.color = color1;
      this.width = width;
      this.img = img;
    }

    CityAnimate.prototype.run = function() {
      return this.wave();
    };

    CityAnimate.prototype.wave = function() {
      this.circle_wave(500);
      this.circle_wave(2000);
      return this.circle_wave(3500);
    };

    CityAnimate.prototype.circle_wave = function(delay) {
      var circle;
      circle = this.layer.insert('circle', '.map-point').attr('cx', this.x).attr('cy', this.y).attr('stroke', this.color).attr('fill', 'transparent');
      return jQuery({
        r: 10,
        o: 1,
        w: this.width
      }).delay(delay).animate({
        r: 100,
        o: 1,
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

    LineChartTitle.prototype.draw = function() {
      this.svg = this.draw_svg();
      return this.draw_texts();
    };

    LineChartTitle.prototype.draw_texts = function() {
      var size, texts;
      texts = this.svg.append('g').style('transform', 'translate(0px, 0px)');
      size = 20;
      texts.append('text').attr('x', 10).attr('y', this.height / 2).attr('dy', '.33em').text('销量对比（单位：万）').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 220).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(205, 255, 65)');
      texts.append('text').attr('x', 260).attr('y', this.height / 2).attr('dy', '.33em').text('当前销量').style('font-size', size + 'px').style('fill', '#ffffff');
      texts.append('rect').attr('x', 360).attr('y', this.height / 2 - 7).attr('width', 30).attr('height', 15).style('fill', 'rgb(60, 180, 236)');
      return texts.append('text').attr('x', 400).attr('y', this.height / 2).attr('dy', '.33em').text('历史销量').style('font-size', size + 'px').style('fill', '#ffffff');
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
      return title = this.svg.append('text').attr('x', 70 + 30).attr('y', 10 + this.TEXT_SIZE / 2).attr('dy', '.33em').text('一带一路国家销售情况监控').style('font-size', this.TEXT_SIZE + 'px').style('fill', '#aebbcb');
    };

    PageTitle.prototype.draw_points = function() {
      var points;
      return points = this.svg.append('image').attr('xlink:href', 'images/title-points.png').attr('width', this.TEXT_SIZE).attr('height', this.TEXT_SIZE).attr('x', 10).attr('y', 10).style('opacity', '0.5');
    };

    return PageTitle;

  })(Graph);

  BaseTile.register('title', PageTitle);

}).call(this);

window.data_path = '/demo1/data'
;
