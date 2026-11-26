// ============================================================================
// KORADEVS MINIGAMES HUB - PHASORLANG (ZERO-GC / SEÑALES PLANAS)
// 0 = Menú Principal | 1 = Mini Sudoku | 2 = Tango | 3 = Queens
// ============================================================================
signal active_game = 0.0
signal difficulty = 1.0
signal score = 0.0
signal streak = 0.0
signal last_click = 0.0
signal game_tick = 0.0
signal best_score = 0.0

in_box(px, py, rx, ry, rw, rh) = {
    hit = 0.0
    if (px >= rx) {
        if (px <= (rx + rw)) {
            if (py >= ry) {
                if (py <= (ry + rh)) {
                    hit = 1.0
                } else { 1.0 }
            } else { 1.0 }
        } else { 1.0 }
    } else { 1.0 }
    hit
}

add_points(base_pts, px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (in_box(px, py, rx, ry, rw, rh) == 1.0) {
        streak = streak + 1.0
        gain = base_pts * difficulty
        score = score + gain
        if (score > best_score) {
            best_score = score
        } else { 1.0 }
        res = 1.0
    } else { 1.0 }
    res
}

select_game(target_id, px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (in_box(px, py, rx, ry, rw, rh) == 1.0) {
        active_game = target_id
        streak = 0.0
        res = 1.0
    } else { 1.0 }
    res
}

cycle_difficulty(px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (in_box(px, py, rx, ry, rw, rh) == 1.0) {
        if (difficulty >= 3.0) {
            difficulty = 1.0
        } else {
            difficulty = difficulty + 1.0
        }
        res = 1.0
    } else { 1.0 }
    res
}

render_top_hud(sw, px, py, clicked) = {
    handled = 0.0
    rect(0.0, 0.0, sw, 44.0, 0x161B22)
    line(0.0, 44.0, sw, 44.0, 0x30363D)

    // Botón [MENU]
    rect(8.0, 8.0, 68.0, 28.0, 0x21262D)
    text("MENU", 18.0, 26.0, 10.0, 0x58A6FF)

    // Botón [NIVEL]
    rect(84.0, 8.0, 74.0, 28.0, 0x1F2937)
    text("NIVEL", 92.0, 26.0, 9.5, 0xD29922)
    text(difficulty, 138.0, 26.0, 10.0, 0xFFFFFF)

    // Marcador PTS y R
    text("PTS:", sw - 120.0, 26.0, 9.5, 0x8B949E)
    text(score, sw - 82.0, 26.0, 10.5, 0x3FB950)
    text("R:", sw - 38.0, 26.0, 9.5, 0x8B949E)
    text(streak, sw - 20.0, 26.0, 10.0, 0x79C0FF)

    if (clicked == 1.0) {
        if (select_game(0.0, px, py, 8.0, 8.0, 68.0, 28.0) == 1.0) {
            handled = 1.0
        } else {
            if (cycle_difficulty(px, py, 84.0, 8.0, 74.0, 28.0) == 1.0) {
                handled = 1.0
            } else { 1.0 }
        }
    } else { 1.0 }
    handled
}

render_main_menu(sw, sh, px, py, clicked) = {
    w = sw - 24.0
    if (w < 180.0) { w = 180.0 } else { 1.0 }

    text("KORADEVS JUEGOS", 12.0, 72.0, 14.0, 0xE6EDF3)
    text("RECORD:", 12.0, 92.0, 9.5, 0x8B949E)
    text(best_score, 74.0, 92.0, 10.0, 0xD29922)

    rect(12.0, 108.0, w, 52.0, 0x161B22)
    rect(12.0, 108.0, 4.0, 52.0, 0x3FB950)
    text("1. MINI SUDOKU", 24.0, 138.0, 11.0, 0xFFFFFF)

    rect(12.0, 170.0, w, 52.0, 0x161B22)
    rect(12.0, 170.0, 4.0, 52.0, 0x58A6FF)
    text("2. TANGO", 24.0, 200.0, 11.0, 0xFFFFFF)

    rect(12.0, 232.0, w, 52.0, 0x161B22)
    rect(12.0, 232.0, 4.0, 52.0, 0xD29922)
    text("3. QUEENS", 24.0, 262.0, 11.0, 0xFFFFFF)

    if (clicked == 1.0) {
        if (select_game(1.0, px, py, 12.0, 108.0, w, 52.0) == 1.0) {
            1.0
        } else {
            if (select_game(2.0, px, py, 12.0, 170.0, w, 52.0) == 1.0) {
                1.0
            } else {
                select_game(3.0, px, py, 12.0, 232.0, w, 52.0)
            }
        }
    } else { 1.0 }
    1.0
}

render_active_game_stub(title_lbl, accent_col, sw, sh, px, py, clicked) = {
    text(title_lbl, 14.0, 76.0, 13.0, accent_col)
    text("DIFICULTAD x", 14.0, 102.0, 10.0, 0x8B949E)
    text(difficulty, 128.0, 102.0, 10.5, 0xFFFFFF)

    gx = 14.0
    gy = 122.0
    cell = 44.0
    rect(gx, gy, cell * 4.0, cell * 4.0, 0x0D1117)
    line(gx + cell, gy, gx + cell, gy + (cell * 4.0), 0x30363D)
    line(gx + (cell * 2.0), gy, gx + (cell * 2.0), gy + (cell * 4.0), 0x30363D)
    line(gx + (cell * 3.0), gy, gx + (cell * 3.0), gy + (cell * 4.0), 0x30363D)
    line(gx, gy + cell, gx + (cell * 4.0), gy + cell, 0x30363D)
    line(gx, gy + (cell * 2.0), gx + (cell * 4.0), gy + (cell * 2.0), 0x30363D)
    line(gx, gy + (cell * 3.0), gx + (cell * 4.0), gy + (cell * 3.0), 0x30363D)

    btn_y = gy + (cell * 4.0) + 18.0
    rect(14.0, btn_y, 176.0, 38.0, 0x238636)
    text("VALIDAR JUGADA (+10)", 24.0, btn_y + 23.0, 10.0, 0xFFFFFF)
    if (clicked == 1.0) {
        add_points(10.0, px, py, 14.0, btn_y, 176.0, 38.0)
    } else { 1.0 }
    1.0
}

screen main {
    sw = R250
    sh = R251
    px = R252
    py = R253
    pd = R254

    if (sw < 200.0) { sw = 360.0 } else { 1.0 }
    if (sh < 200.0) { sh = 640.0 } else { 1.0 }

    game_tick = game_tick + 1.0

    clicked = 0.0
    if (pd == 1.0) {
        if (last_click == 0.0) {
            if (px > 0.0) {
                clicked = 1.0
            } else { 1.0 }
        } else { 1.0 }
    } else { 1.0 }
    last_click = pd

    cls(0x090D13)
    hud_hit = render_top_hud(sw, px, py, clicked)

    body_click = 0.0
    if (clicked == 1.0) {
        if (hud_hit == 0.0) {
            body_click = 1.0
        } else { 1.0 }
    } else { 1.0 }

    if (active_game == 0.0) {
        render_main_menu(sw, sh, px, py, body_click)
    } else {
        if (active_game == 1.0) {
            render_active_game_stub("MINI SUDOKU", 0x3FB950, sw, sh, px, py, body_click)
        } else {
            if (active_game == 2.0) {
                render_active_game_stub("TANGO", 0x58A6FF, sw, sh, px, py, body_click)
            } else {
                render_active_game_stub("QUEENS", 0xD29922, sw, sh, px, py, body_click)
            }
        }
    }
}
