/*
 * $Id: stagemanager.d,v 1.5 2005/01/09 03:49:59 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.stagemanager;

import std.string;
import std.math;
import bulletml;
import abagames.util.vector;
import abagames.util.rand;
import abagames.tt.enemy;
import abagames.tt.barrage;
import abagames.tt.shape;
import abagames.tt.ship;
import abagames.tt.tunnel;

/**
 * Manage an enemys' appearance and a torus.
 */
public class StageManager {
 private:
  static const int[] BOSS_APP_RANK = [100, 160, 250];
  static const float LEVEL_UP_RATIO = 0.5;
  static const float[][] TUNNEL_COLOR_PATTERN_POLY = [
    [0.7, 0.9, 1], [0.6, 1, 0.8], [0.9, 0.7, 0.6], [0.8, 0.8, 0.8],
    [0.5, 0.9, 0.9], [0.7, 0.9, 0.6], [0.8, 0.5, 0.9],
    ];
  static const float[][] TUNNEL_COLOR_PATTERN_LINE = [
    [0.6, 0.7, 1], [0.4, 0.8, 0.6], [0.7, 0.5, 0.6], [0.6, 0.6, 0.6],
    [0.4, 0.7, 0.7], [0.6, 0.7, 0.5], [0.6, 0.4, 1],
    ];
  Tunnel tunnel;
  Torus torus;
  EnemyPool enemies;
  Ship ship;
  ShipSpec[] smallShipSpec, middleShipSpec, bossShipSpec;
  Rand rand;
  float nextSmallAppDist, nextMiddleAppDist, nextBossAppDist;
  int bossNum;
  int bossAppRank, zoneEndRank;
  int bossSpecIdx;
  float _level;
  int grade;
  int bossModeEndCnt;
  bool _middleBossZone;
  int tunnelColorPolyIdx, tunnelColorLineIdx;
  static const int TUNNEL_COLOR_CHANGE_INTERVAL = 60;
  int tunnelColorChangeCnt;

  public this(Tunnel tunnel, EnemyPool enemies, Ship ship) {
    this.tunnel = tunnel;
    this.enemies = enemies;
    this.ship = ship;
    rand = new Rand;
    torus = new Torus;
    ShipSpec.createBulletShape();
    smallShipSpec = middleShipSpec = bossShipSpec = null;
  }

  public void start(float level, int grade, long seed) {
    rand.setSeed(seed);
    torus.create(seed);
    tunnel.start(torus);
    this._level = level - LEVEL_UP_RATIO;
    this.grade = grade;
    zoneEndRank = 0;
    _middleBossZone = false;
    Slice.darkLine = true;
    Slice.darkLineRatio = 1;
    tunnelColorPolyIdx = cast(int)TUNNEL_COLOR_PATTERN_POLY.length + cast(int) level - 2;
    tunnelColorLineIdx = cast(int)TUNNEL_COLOR_PATTERN_LINE.length + cast(int) level - 2;
    createNextZone();
  }

  private void createNextZone() {
    _level += LEVEL_UP_RATIO;
    _middleBossZone = !_middleBossZone;
    if (Slice.darkLine) {
      tunnelColorPolyIdx++;
      tunnelColorLineIdx++;
    }
    Slice.darkLine = !Slice.darkLine;
    tunnelColorChangeCnt = TUNNEL_COLOR_CHANGE_INTERVAL;
    enemies.clear();
    closeShipSpec();
    smallShipSpec = null;
    for (int i = 0; i < 2 + rand.nextInt(2); i++) {
      ShipSpec ss = new ShipSpec;
      ss.createSmall(rand, _level * 1.8f, grade);
      smallShipSpec ~= ss;
    }
    middleShipSpec = null;
    for (int i = 0; i < 2 + rand.nextInt(2); i++) {
      ShipSpec ss = new ShipSpec;
      ss.createMiddle(rand, _level * 1.9f);
      middleShipSpec ~= ss;
    }
    nextSmallAppDist = nextMiddleAppDist = 0;
    setNextSmallAppDist();
    setNextMiddleAppDist();
    bossShipSpec = null;
    if (_middleBossZone && _level > 5 && rand.nextInt(3) != 0) {
      bossNum = 1 + rand.nextInt(cast(int) sqrt(_level / 5) + 1);
      if (bossNum > 4)
        bossNum = 4;
    } else {
      bossNum = 1;
    }
    for (int i = 0; i < bossNum ; i++) {
      ShipSpec ss = new ShipSpec;
      float lv = _level * 2.0f / bossNum;
      if (_middleBossZone)
        lv *= 1.33f;
      ss.createBoss(rand, lv,
                    0.8 + grade * 0.04 + rand.nextFloat(0.03), _middleBossZone);
      bossShipSpec ~= ss;
    }
    bossAppRank = BOSS_APP_RANK[grade] - bossNum + zoneEndRank;
    zoneEndRank += BOSS_APP_RANK[grade];
    ship.setBossApp(bossAppRank, bossNum, zoneEndRank);
    bossSpecIdx = 0;
    nextBossAppDist = 9999999;
    bossModeEndCnt = -1;
  }

  public void move() {
    if (ship.inBossMode) {
      if (nextBossAppDist > 99999) {
        nextBossAppDist = rand.nextInt(50) + 100;
        nextSmallAppDist = nextMiddleAppDist = 9999999;
      }
      nextBossAppDist -= ship.speed;
      if (bossNum > 0 && nextBossAppDist <= 0) {
        addEnemy(bossShipSpec[bossSpecIdx],
                 Ship.IN_SIGHT_DEPTH_DEFAULT * 4, rand);
        bossNum--;
        nextBossAppDist = rand.nextInt(30) + 60;
        bossSpecIdx++;
      }
      if (bossNum <= 0 && enemies.getNum() <= 0)
        ship.gotoNextZoneForced();
      return;
    } else {
      if (nextBossAppDist < 99999) {
        // Player's ship destoryed or overtook all bosses.
        bossModeEndCnt = 60;
        nextSmallAppDist = nextMiddleAppDist = nextBossAppDist = 9999999;
      }
      if (bossModeEndCnt >= 0) {
        bossModeEndCnt--;
        ship.clearVisibleBullets();
        if (bossModeEndCnt < 0) {
          createNextZone();
          ship.startNextZone();
        }
      }
    }
    nextSmallAppDist -= ship.speed;
    if (nextSmallAppDist <= 0) {
      addEnemy(smallShipSpec[rand.nextInt(cast(int)smallShipSpec.length)],
               Ship.IN_SIGHT_DEPTH_DEFAULT * (4 + rand.nextFloat(0.5)), rand);
      setNextSmallAppDist();
    }
    nextMiddleAppDist -= ship.speed;
    if (nextMiddleAppDist <= 0) {
      addEnemy(middleShipSpec[rand.nextInt(cast(int)middleShipSpec.length)],
               Ship.IN_SIGHT_DEPTH_DEFAULT * (4 + rand.nextFloat(0.5)), rand);
      setNextMiddleAppDist();
    }
    if (tunnelColorChangeCnt > 0) {
      tunnelColorChangeCnt--;
      if (Slice.darkLine) {
        Slice.darkLineRatio += 1.0f / TUNNEL_COLOR_CHANGE_INTERVAL;
      } else {
        Slice.darkLineRatio -= 1.0f / TUNNEL_COLOR_CHANGE_INTERVAL;
        float cRatio = cast(float) tunnelColorChangeCnt / TUNNEL_COLOR_CHANGE_INTERVAL;
        int cpIdxPrev = (tunnelColorPolyIdx - 1) % cast(int)TUNNEL_COLOR_PATTERN_POLY.length;
        int cpIdxNow = tunnelColorPolyIdx % cast(int)TUNNEL_COLOR_PATTERN_POLY.length;
        Slice.polyR = TUNNEL_COLOR_PATTERN_POLY[cpIdxPrev][0] * cRatio +
          TUNNEL_COLOR_PATTERN_POLY[cpIdxNow][0] * (1 - cRatio);
        Slice.polyG = TUNNEL_COLOR_PATTERN_POLY[cpIdxPrev][1] * cRatio +
          TUNNEL_COLOR_PATTERN_POLY[cpIdxNow][1] * (1 - cRatio);
        Slice.polyB = TUNNEL_COLOR_PATTERN_POLY[cpIdxPrev][2] * cRatio +
          TUNNEL_COLOR_PATTERN_POLY[cpIdxNow][2] * (1 - cRatio);
        int clIdxPrev = (tunnelColorLineIdx - 1) % cast(int)TUNNEL_COLOR_PATTERN_LINE.length;
        int clIdxNow = tunnelColorLineIdx % cast(int)TUNNEL_COLOR_PATTERN_LINE.length;
        Slice.lineR = TUNNEL_COLOR_PATTERN_LINE[clIdxPrev][0] * cRatio +
          TUNNEL_COLOR_PATTERN_LINE[clIdxNow][0] * (1 - cRatio);
        Slice.lineG = TUNNEL_COLOR_PATTERN_LINE[clIdxPrev][1] * cRatio +
          TUNNEL_COLOR_PATTERN_LINE[clIdxNow][1] * (1 - cRatio);
        Slice.lineB = TUNNEL_COLOR_PATTERN_LINE[clIdxPrev][2] * cRatio +
          TUNNEL_COLOR_PATTERN_LINE[clIdxNow][2] * (1 - cRatio);
      }
    }
  }

  private void setNextSmallAppDist() {
    nextSmallAppDist += rand.nextInt(16) + 6;
  }

  private void setNextMiddleAppDist() {
    nextMiddleAppDist += rand.nextInt(200) + 33;
  }

  private void addEnemy(ShipSpec spec, float y, Rand rand) {
    Enemy en = enemies.getInstance();
    if (!en)
      return;
    Slice sl = tunnel.getSlice(y);
    float x;
    if (sl.isNearlyRound()) {
      x = rand.nextFloat(PI);
    } else {
      float ld = sl.getLeftEdgeDeg();
      float rd = sl.getRightEdgeDeg();
      float wd = rd - ld;
      if (wd < 0)
        wd += PI * 2;
      x = ld + rand.nextFloat(wd);
    }
    if (x < 0)
      x += PI * 2;
    else if (x >= PI * 2)
      x -= PI * 2;
    en.set(spec, x, y, rand);
  }

  public void closeStage() {
    closeShipSpec();
    torus.close();
  }

  public void close() {
    closeStage();
    ShipSpec.closeBulletShape();
  }

  private void closeShipSpec() {
    if (smallShipSpec)
      foreach (ShipSpec ss; smallShipSpec)
        ss.close();
    if (middleShipSpec)
      foreach (ShipSpec ss; middleShipSpec)
        ss.close();
    if (bossShipSpec)
      foreach (ShipSpec ss; bossShipSpec)
        ss.close();
  }

  public float level() {
    return _level;
  }

  public bool middleBossZone() {
    return _middleBossZone;
  }
}

/**
 * Enemy's ship specifications.
 */
public class ShipSpec {
 private:
  static const float SPEED_CHANGE_RATIO = 0.2;
  static BulletShape[] bulletShape;
  static BitShape _bitShape;
  ShipShape _shape, _damagedShape;
  Barrage _barrage;
  int _shield;
  float baseSpeed, shipSpeedRatio;
  float visualRange;
  float baseBank;
  int ocsMoveInterval;
  float bankMax;
  int _score;
  int _bitNum;
  static enum BitType {
    ROUND, LINE
  };
  int bitType;
  float bitDistance;
  float bitMd;
  Barrage _bitBarrage;
  bool _aimShip;
  bool _hasLimitY;
  bool _noFireDepthLimit;
  bool _isBoss;

  public static void createBulletShape() {
    BulletShape bs;
    for (int i = 0; i < BulletShape.NUM; i++) {
      bs = new BulletShape;
      bs.create(cast(BulletShape.BSType)i);
      bulletShape ~= bs;
    }
    _bitShape = new BitShape;
    _bitShape.create();
  }

  public static void closeBulletShape() {
    foreach (BulletShape bs; bulletShape)
      bs.close();
  }

  public void createSmall(Rand rand, float level, int grade) {
    _shield = 1;
    baseSpeed = 0.05 + rand.nextFloat(0.1);
    shipSpeedRatio = 0.25 + rand.nextFloat(0.25);
    visualRange = 10 + rand.nextFloat(32);
    bankMax = 0.3 + rand.nextFloat(0.7);
    if (rand.nextInt(3) == 0)
      baseBank = 0.1 + rand.nextFloat(0.2);
    else
      baseBank = 0;
    long rs = rand.nextInt(99999);
    _shape = new ShipShape();
    _shape.create(rs, ShipShape.Type.SMALL);
    _damagedShape = new ShipShape();
    _damagedShape.create(rs, ShipShape.Type.SMALL, true);
    int brgInterval;
    int biMin = cast(int)(160.0f / level);
    if (biMin > 80)
      biMin = 80;
    else if (biMin < 40)
      biMin = 40;
    biMin += (Ship.GRADE_NUM - 1 - grade) * 8;
    brgInterval = biMin + rand.nextInt(80 + (Ship.GRADE_NUM - 1 - grade) * 8 - biMin);
    float brgRank = level;
    brgRank /= (150.0f / brgInterval);
    _barrage = createBarrage(rand, brgRank, 0, brgInterval);
    _score = 100;
    _bitNum = 0;
    _aimShip = _hasLimitY = _noFireDepthLimit = _isBoss = false;
  }

  public void createMiddle(Rand rand, float level) {
    _shield = 10;
    baseSpeed = 0.1 + rand.nextFloat(0.1);
    shipSpeedRatio = 0.4 + rand.nextFloat(0.4);
    visualRange = 10 + rand.nextFloat(32);
    bankMax = 0.2 + rand.nextFloat(0.5);
    if (rand.nextInt(4) == 0)
      baseBank = 0.05 + rand.nextFloat(0.1);
    else
      baseBank = 0;
    long rs = rand.nextInt(99999);
    _shape = new ShipShape();
    _shape.create(rs, ShipShape.Type.MIDDLE);
    _damagedShape = new ShipShape();
    _damagedShape.create(rs, ShipShape.Type.MIDDLE, true);
    _barrage = createBarrage(rand, level, 0, 0, 1,
                             "middle", BulletShape.BSType.SQUARE);
    _score = 500;
    _bitNum = 0;
    _aimShip = _hasLimitY = _noFireDepthLimit = _isBoss = false;
  }

  public void createBoss(Rand rand, float level, float speed, bool middleBoss) {
    _shield = 30;
    baseSpeed = 0.1 + rand.nextFloat(0.1);
    shipSpeedRatio = speed;
    visualRange = 16 + rand.nextFloat(24);
    bankMax = 0.8 + rand.nextFloat(0.4);
    baseBank = 0;
    long rs = rand.nextInt(99999);
    _shape = new ShipShape();
    _shape.create(rs, ShipShape.Type.LARGE);
    _damagedShape = new ShipShape();
    _damagedShape.create(rs, ShipShape.Type.LARGE, true);
    _barrage = createBarrage(rand, level, 0, 0, 1.2f,
                             "middle", BulletShape.BSType.SQUARE, true);
    _score = 2000;
    _aimShip = _hasLimitY = _noFireDepthLimit = _isBoss = true;
    if (middleBoss) {
      _bitNum = 0;
      return;
    }
    _bitNum = 2 + rand.nextInt(3) * 2;
    bitType = rand.nextInt(2);
    bitDistance = 0.33 + rand.nextFloat(0.3);
    bitMd = 0.02 + rand.nextFloat(0.02);
    float bitBrgRank = level;
    bitBrgRank /= (bitNum / 2);
    int brgInterval;
    int biMin = cast(int)(120.0f / bitBrgRank);
    if (biMin > 60)
      biMin = 60;
    else if (biMin < 20)
      biMin = 20;
    brgInterval = biMin + rand.nextInt(60 - biMin);
    bitBrgRank /= (60.0f / brgInterval);
    _bitBarrage = createBarrage(rand, bitBrgRank, 0, brgInterval, 1, null,
                                BulletShape.BSType.BAR, true);
    _bitBarrage.setNoXReverse();
  }

  public void close() {
    _shape.close();
  }

  private Barrage createBarrage(Rand rand,
                                float level,
                                int preWait, int postWait,
                                float size = 1, string baseDir = null,
                                int shapeIdx = 0,
                                bool longRange = false) {
    if (level < 0)
      return null;
    float rank = sqrt(level) / (8 - rand.nextInt(3));
    if (rank > 0.8)
      rank = rand.nextFloat(0.2) + 0.8;
    level /= (rank + 2);
    float speedRank = sqrt(rank) * (rand.nextFloat(0.2) + 0.8);
    if (speedRank < 1)
      speedRank = 1;
    if (speedRank > 2)
      speedRank = sqrt(speedRank * 2);
    float morphRank = level / speedRank;
    int morphCnt = 0;
    while (morphRank > 1) {
      morphCnt++;
      morphRank /= 3;
    }
    Barrage br = new Barrage;
    ResizableDrawable bsr = new ResizableDrawable;
    bsr.shape = bulletShape[shapeIdx];
    bsr.size = size * 1.25f;
    ResizableDrawable dbsr = new ResizableDrawable;
    dbsr.shape = bulletShape[shapeIdx + 1];
    dbsr.size = size * 1.25f;
    br.setShape(bsr, dbsr);
    br.setWait(preWait, postWait);
    br.setLongRange(longRange);
    BulletMLParserTinyXML*[] ps;
    int psn;
    if (baseDir) {
      ps = BarrageManager.getInstanceList(baseDir);
      int pi = rand.nextInt(cast(int)ps.length);
      br.addBml(ps[pi], rank, true, speedRank);
    } else {
      br.addBml("basic", "straight.xml", rank, true, speedRank);
    }
    ps = BarrageManager.getInstanceList("morph");
    psn = cast(int)ps.length;
    for (int i = 0; i < morphCnt; i++) {
      int pi = rand.nextInt(cast(int)ps.length);
      while (!ps[pi]) {
        pi--;
        if (pi < 0)
          pi = cast(int)ps.length - 1;
      }
      br.addBml(ps[pi], morphRank, true, speedRank);
      ps[pi].destroy();
      psn--;
    }
    return br;
  }

  public void setSpeed(ref float sp) {
    changeSpeed(sp, baseSpeed);
  }

  public void setSpeed(ref float sp, float shipSp) {
    float as = shipSp * shipSpeedRatio;
    if (as > baseSpeed)
      changeSpeed(sp, as);
    else
      changeSpeed(sp, baseSpeed);
  }

  private void changeSpeed(ref float sp, float aim) {
    sp += (aim - sp) * SPEED_CHANGE_RATIO;
  }

  public bool getRangeOfMovement(out float from, out float to, Vector p, Tunnel tunnel) {
    float py = p.y;
    Slice cs = tunnel.getSlice(py);
    py += visualRange;
    Slice vs = tunnel.getSlice(py);
    if (!cs.isNearlyRound()) {
      from = cs.getLeftEdgeDeg();
      to = cs.getRightEdgeDeg();
      if (!vs.isNearlyRound()) {
        float vld = vs.getLeftEdgeDeg();
        float vrd = vs.getRightEdgeDeg();
        if (Tunnel.checkDegInside(from, vld, vrd) == -1)
          from = vld;
        if (Tunnel.checkDegInside(to, vld, vrd) == 1)
          to = vrd;
      }
      return true;
    } else if (!vs.isNearlyRound()) {
      from = vs.getLeftEdgeDeg();
      to = vs.getRightEdgeDeg();
      return true;
    } else {
      return false;
    }
  }

  public void tryToMove(ref float bank, float deg, float aimDeg) {
    float bk = aimDeg - deg;
    if (bk > PI)
      bk -= PI * 2;
    else if (bk < -PI)
      bk += PI * 2;
    if (bk > bankMax)
      bk = bankMax;
    else if (bk < -bankMax)
      bk = -bankMax;
    bank += (bk - bank) * 0.1;
  }

  public void handleLimitY(ref float y, ref float limitY) {
    if (y > limitY)
      y += (limitY - y) * 0.05f;
    else
      limitY += (y - limitY) * 0.05f;
    limitY -= 0.01f;
  }

  public float createBaseBank(Rand rand) {
    return rand.nextSignedFloat(baseBank);
  }

  public void getBitOffset(Vector ofs, ref float deg, int idx, int cnt) {
    final switch (bitType) {
    case BitType.ROUND:
      float od = PI * 2 / bitNum;
      float d = od * idx + cnt * bitMd;
      ofs.x = bitDistance * 2 * sin(d);
      ofs.y = bitDistance * 2 * cos(d) * 5;
      deg = PI - sin(d) * 0.05f;
      break;
    case BitType.LINE:
      float of = (idx % 2) * 2 - 1;
      int oi = cast(int) (idx / 2) + 1;
      ofs.x = bitDistance * 1.5f * oi * of;
      ofs.y = 0;
      deg = PI;
      break;
    }
  }

  public static BitShape bitShape() {
    return _bitShape;
  }
 
  public ShipShape shape() {
    return _shape;
  }

  public ShipShape damagedShape() {
    return _damagedShape;
  }

  public int shield() {
    return _shield;
  }

  public Barrage barrage() {
    return _barrage;
  }

  public int score() {
    return _score;
  }

  public bool aimShip() {
    return _aimShip;
  }

  public bool hasLimitY() {
    return _hasLimitY;
  }

  public bool noFireDepthLimit() {
    return _noFireDepthLimit;
  }

  public Barrage bitBarrage() {
    return _bitBarrage;
  }

  public int bitNum() {
    return _bitNum;
  }

  public bool isBoss() {
    return _isBoss;
  }
}
