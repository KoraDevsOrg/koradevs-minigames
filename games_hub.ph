import "@store/ui/base.ph" -reutilizar
import "@store/ui/grid.ph" -reutilizar

// 0 = Menú Principal | 1 = Mini Sudoku | 2 = Tango | 3 = Queens
signal active_game = 0.0
signal difficulty = 1.0
signal score = 0.0
signal streak = 0.0
signal last_click = 0.0
signal game_tick = 0.0
signal best_score = 0.0

// Tablero 4x4 plano en señales (Zero-GC) — Pistas fijas: s0=1, s5=2, s10=3, s15=4
signal s0 = 1.0
signal s1 = 0.0
signal s2 = 0.0
signal s3 = 0.0
signal s4 = 0.0
signal s5 = 2.0
signal s6 = 0.0
signal s7 = 0.0
signal s8 = 0.0
signal s9 = 0.0
signal s10 = 3.0
signal s11 = 0.0
signal s12 = 0.0
signal s13 = 0.0
signal s14 = 0.0
signal s15 = 4.0

select_game(target_id, px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (hit_rect(px, py, rx, ry, rw, rh) == 1.0) {
        active_game = target_id
        streak = 0.0
        res = 1.0
    } else { 0.0 }
    res
}

cycle_difficulty(px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (hit_rect(px, py, rx, ry, rw, rh) == 1.0) {
        if (difficulty >= 3.0) {
            difficulty = 1.0
        } else {
            difficulty = difficulty + 1.0
        }
        res = 1.0
    } else { 0.0 }
    res
}

add_points(base_pts, px, py, rx, ry, rw, rh) = {
    res = 0.0
    if (hit_rect(px, py, rx, ry, rw, rh) == 1.0) {
        streak = streak + 1.0
        score = score + (base_pts * difficulty)
        if (score > best_score) {
            best_score = score
        } else { 0.0 }
        res = 1.0
    } else { 0.0 }
    res
}

next_val(v) = {
    nv = v + 1.0
    if (nv > 4.0) { nv = 0.0 } else { 0.0 }
    nv
}

sudoku_toggle_cell(idx) = {
    if (idx == 1.0) { s1 = next_val(s1) } else { 0.0 }
    if (idx == 2.0) { s2 = next_val(s2) } else { 0.0 }
    if (idx == 3.0) { s3 = next_val(s3) } else { 0.0 }
    if (idx == 4.0) { s4 = next_val(s4) } else { 0.0 }
    if (idx == 6.0) { s6 = next_val(s6) } else { 0.0 }
    if (idx == 7.0) { s7 = next_val(s7) } else { 0.0 }
    if (idx == 8.0) { s8 = next_val(s8) } else { 0.0 }
    if (idx == 9.0) { s9 = next_val(s9) } else { 0.0 }
    if (idx == 11.0) { s11 = next_val(s11) } else { 0.0 }
    if (idx == 12.0) { s12 = next_val(s12) } else { 0.0 }
    if (idx == 13.0) { s13 = next_val(s13) } else { 0.0 }
    if (idx == 14.0) { s14 = next_val(s14) } else { 0.0 }
    1.0
}

draw_cell_num(gx, gy, col, row, cell, val, col_hex) = {
    if (val > 0.0) {
        tx = gx + (col * cell) + (cell * 0.40)
        ty = gy + (row * cell) + (cell * 0.34)
        text(val, tx, ty, 20.0, col_hex)
    } else { 0.0 }
    1.0
}

render_top_hud(sw, px, py, clicked) = {
    handled = 0.0
    rect(0.0, 0.0, sw, 48.0, 0x161B22)
    line(0.0, 48.0, sw, 48.0, 0x30363D)

    draw_btn(8.0, 8.0, 72.0, 32.0, 0x21262D, 0x30363D, "MENU", 20.0, 18.0, 0x58A6FF)
    draw_btn(88.0, 8.0, 78.0, 32.0, 0x1F2937, 0x30363D, "NIVEL", 96.0, 18.0, 0xD29922)
    text(difficulty, 144.0, 18.0, 10.0, 0xFFFFFF)

    text("PTS:", sw - 122.0, 18.0, 9.5, 0x8B949E)
    text(score, sw - 84.0, 18.0, 10.5, 0x3FB950)
    text("R:", sw - 38.0, 18.0, 9.5, 0x8B949E)
    text(streak, sw - 20.0, 18.0, 10.0, 0x79C0FF)

    if (clicked == 1.0) {
        if (select_game(0.0, px, py, 8.0, 8.0, 72.0, 32.0) == 1.0) {
            handled = 1.0
        } else {
            if (cycle_difficulty(px, py, 88.0, 8.0, 78.0, 32.0) == 1.0) {
                handled = 1.0
            } else { 0.0 }
        }
    } else { 0.0 }
    handled
}

render_main_menu(sw, sh, px, py, clicked) = {
    bw = grid_board_w(sw, 12.0, 420.0)
    ox = grid_origin_x(sw, bw)

    text("KORADEVS JUEGOS", ox, 66.0, 14.0, 0xE6EDF3)
    text("RECORD:", ox, 88.0, 9.5, 0x8B949E)
    text(best_score, ox + 62.0, 88.0, 10.0, 0xD29922)

    card_h = 56.0
    y1 = 112.0
    y2 = 182.0
    y3 = 252.0

    draw_btn(ox, y1, bw, card_h, 0x161B22, 0x3FB950, "1. MINI SUDOKU", ox + 14.0, y1 + 22.0, 0xFFFFFF)
    draw_btn(ox, y2, bw, card_h, 0x161B22, 0x58A6FF, "2. TANGO", ox + 14.0, y2 + 22.0, 0xFFFFFF)
    draw_btn(ox, y3, bw, card_h, 0x161B22, 0xD29922, "3. QUEENS", ox + 14.0, y3 + 22.0, 0xFFFFFF)

    if (clicked == 1.0) {
        if (select_game(1.0, px, py, ox, y1, bw, card_h) == 1.0) {
            0.0
        } else {
            if (select_game(2.0, px, py, ox, y2, bw, card_h) == 1.0) {
                0.0
            } else {
                select_game(3.0, px, py, ox, y3, bw, card_h)
            }
        }
    } else { 0.0 }
    1.0
}

render_mini_sudoku(sw, sh, px, py, clicked) = {
    bw = grid_board_w(sw, 12.0, 420.0)
    gx = grid_origin_x(sw, bw)
    gy = 110.0
    cell = bw / 4.0

    text("MINI SUDOKU 4x4", gx, 64.0, 13.0, 0x3FB950)
    text("Toca una casilla para cambiar (1-4)", gx, 86.0, 9.5, 0x8B949E)

    grid_draw(gx, gy, 4.0, 4.0, cell, 0x0D1117, 0x30363D, 0x58A6FF)

    // Divisores de subcuadrícula 2x2
    line(gx + (cell * 2.0), gy, gx + (cell * 2.0), gy + bw, 0x58A6FF)
    line(gx, gy + (cell * 2.0), gx + bw, gy + (cell * 2.0), 0x58A6FF)

    // Renderizado de las 16 celdas
    draw_cell_num(gx, gy, 0.0, 0.0, cell, s0, 0x58A6FF)
    draw_cell_num(gx, gy, 1.0, 0.0, cell, s1, 0x3FB950)
    draw_cell_num(gx, gy, 2.0, 0.0, cell, s2, 0x3FB950)
    draw_cell_num(gx, gy, 3.0, 0.0, cell, s3, 0x3FB950)

    draw_cell_num(gx, gy, 0.0, 1.0, cell, s4, 0x3FB950)
    draw_cell_num(gx, gy, 1.0, 1.0, cell, s5, 0x58A6FF)
    draw_cell_num(gx, gy, 2.0, 1.0, cell, s6, 0x3FB950)
    draw_cell_num(gx, gy, 3.0, 1.0, cell, s7, 0x3FB950)

    draw_cell_num(gx, gy, 0.0, 2.0, cell, s8, 0x3FB950)
    draw_cell_num(gx, gy, 1.0, 2.0, cell, s9, 0x3FB950)
    draw_cell_num(gx, gy, 2.0, 2.0, cell, s10, 0x58A6FF)
    draw_cell_num(gx, gy, 3.0, 2.0, cell, s11, 0x3FB950)

    draw_cell_num(gx, gy, 0.0, 3.0, cell, s12, 0x3FB950)
    draw_cell_num(gx, gy, 1.0, 3.0, cell, s13, 0x3FB950)
    draw_cell_num(gx, gy, 2.0, 3.0, cell, s14, 0x3FB950)
    draw_cell_num(gx, gy, 3.0, 3.0, cell, s15, 0x58A6FF)

    btn_y = gy + bw + 16.0
    draw_btn(gx, btn_y, bw, 42.0, 0x238636, 0x2EA043, "VALIDAR JUGADA (+10)", gx + 14.0, btn_y + 15.0, 0xFFFFFF)

    if (clicked == 1.0) {
        hit_i = grid_hit_index(px, py, gx, gy, 4.0, 4.0, cell)
        if (hit_i >= 0.0) {
            sudoku_toggle_cell(hit_i)
        } else {
            add_points(10.0, px, py, gx, btn_y, bw, 42.0)
        }
    } else { 0.0 }
    1.0
}

render_active_game_stub(title_lbl, accent_col, sw, sh, px, py, clicked) = {
    bw = grid_board_w(sw, 12.0, 420.0)
    gx = grid_origin_x(sw, bw)
    gy = 110.0
    cell = bw / 4.0

    text(title_lbl, gx, 64.0, 13.0, accent_col)
    text("DIFICULTAD x", gx, 86.0, 9.5, 0x8B949E)
    text(difficulty, gx + 104.0, 86.0, 10.0, 0xFFFFFF)

    grid_draw(gx, gy, 4.0, 4.0, cell, 0x0D1117, 0x30363D, accent_col)

    btn_y = gy + bw + 16.0
    draw_btn(gx, btn_y, bw, 42.0, 0x238636, 0x2EA043, "VALIDAR JUGADA (+10)", gx + 14.0, btn_y + 15.0, 0xFFFFFF)
    if (clicked == 1.0) {
        add_points(10.0, px, py, gx, btn_y, bw, 42.0)
    } else { 0.0 }
    1.0
}

screen main {
    sw = R250
    sh = R251
    px = R252
    py = R253
    pd = R254

    if (sw < 200.0) { sw = 360.0 } else { 0.0 }
    if (sh < 200.0) { sh = 640.0 } else { 0.0 }

    game_tick = game_tick + 1.0

    clicked = 0.0
    if (pd == 1.0) {
        if (last_click == 0.0) {
            if (px > 0.0) {
                clicked = 1.0
            } else { 0.0 }
        } else { 0.0 }
    } else { 0.0 }
    last_click = pd

    cls(0x090D13)
    hud_hit = render_top_hud(sw, px, py, clicked)

    body_click = 0.0
    if (clicked == 1.0) {
        if (hud_hit == 0.0) {
            body_click = 1.0
        } else { 0.0 }
    } else { 0.0 }

    if (active_game == 0.0) {
        render_main_menu(sw, sh, px, py, body_click)
    } else {
        if (active_game == 1.0) {
            render_mini_sudoku(sw, sh, px, py, body_click)
        } else {
            if (active_game == 2.0) {
                render_active_game_stub("TANGO", 0x58A6FF, sw, sh, px, py, body_click)
            } else {
                render_active_game_stub("QUEENS", 0xD29922, sw, sh, px, py, body_click)
            }
        }
    }
}
