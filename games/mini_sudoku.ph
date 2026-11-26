// ============================================================================
// MINI SUDOKU 6x6 (ESTILO LINKEDIN: 3 FILAS x 2 COLUMNAS DE CAJAS 2x3)
// Pulido UX Zero-GC: guía fila/col/caja, conflictos en vivo, timer y win-lock
// ============================================================================
signal s0 = 1.0
signal s1 = 0.0
signal s2 = 3.0
signal s3 = 0.0
signal s4 = 5.0
signal s5 = 0.0

signal s6 = 0.0
signal s7 = 5.0
signal s8 = 0.0
signal s9 = 1.0
signal s10 = 0.0
signal s11 = 0.0

signal s12 = 2.0
signal s13 = 0.0
signal s14 = 0.0
signal s15 = 5.0
signal s16 = 0.0
signal s17 = 4.0

signal s18 = 0.0
signal s19 = 6.0
signal s20 = 0.0
signal s21 = 0.0
signal s22 = 3.0
signal s23 = 0.0

signal s24 = 0.0
signal s25 = 1.0
signal s26 = 0.0
signal s27 = 6.0
signal s28 = 0.0
signal s29 = 5.0

signal s30 = 6.0
signal s31 = 0.0
signal s32 = 0.0
signal s33 = 0.0
signal s34 = 1.0
signal s35 = 0.0

signal s_sel = 1.0
signal s_sel_val = 0.0
signal s_msg = 0.0
signal s_won = 0.0
signal s_frames = 0.0
signal s_gx = 12.0
signal s_gy = 104.0
signal s_cell = 56.0
signal s_bw = 336.0

sudoku_is_fixed(idx) = {
    fx = 0.0
    if (idx == 0.0) { fx = 1.0 } else { 0.0 }
    if (idx == 2.0) { fx = 1.0 } else { 0.0 }
    if (idx == 4.0) { fx = 1.0 } else { 0.0 }
    if (idx == 7.0) { fx = 1.0 } else { 0.0 }
    if (idx == 9.0) { fx = 1.0 } else { 0.0 }
    if (idx == 12.0) { fx = 1.0 } else { 0.0 }
    if (idx == 15.0) { fx = 1.0 } else { 0.0 }
    if (idx == 17.0) { fx = 1.0 } else { 0.0 }
    if (idx == 19.0) { fx = 1.0 } else { 0.0 }
    if (idx == 22.0) { fx = 1.0 } else { 0.0 }
    if (idx == 25.0) { fx = 1.0 } else { 0.0 }
    if (idx == 27.0) { fx = 1.0 } else { 0.0 }
    if (idx == 29.0) { fx = 1.0 } else { 0.0 }
    if (idx == 30.0) { fx = 1.0 } else { 0.0 }
    if (idx == 34.0) { fx = 1.0 } else { 0.0 }
    fx
}

sudoku_get_val(idx) = {
    v = 0.0
    if (idx == 0.0) { v = s0 } else { 0.0 }
    if (idx == 1.0) { v = s1 } else { 0.0 }
    if (idx == 2.0) { v = s2 } else { 0.0 }
    if (idx == 3.0) { v = s3 } else { 0.0 }
    if (idx == 4.0) { v = s4 } else { 0.0 }
    if (idx == 5.0) { v = s5 } else { 0.0 }
    if (idx == 6.0) { v = s6 } else { 0.0 }
    if (idx == 7.0) { v = s7 } else { 0.0 }
    if (idx == 8.0) { v = s8 } else { 0.0 }
    if (idx == 9.0) { v = s9 } else { 0.0 }
    if (idx == 10.0) { v = s10 } else { 0.0 }
    if (idx == 11.0) { v = s11 } else { 0.0 }
    if (idx == 12.0) { v = s12 } else { 0.0 }
    if (idx == 13.0) { v = s13 } else { 0.0 }
    if (idx == 14.0) { v = s14 } else { 0.0 }
    if (idx == 15.0) { v = s15 } else { 0.0 }
    if (idx == 16.0) { v = s16 } else { 0.0 }
    if (idx == 17.0) { v = s17 } else { 0.0 }
    if (idx == 18.0) { v = s18 } else { 0.0 }
    if (idx == 19.0) { v = s19 } else { 0.0 }
    if (idx == 20.0) { v = s20 } else { 0.0 }
    if (idx == 21.0) { v = s21 } else { 0.0 }
    if (idx == 22.0) { v = s22 } else { 0.0 }
    if (idx == 23.0) { v = s23 } else { 0.0 }
    if (idx == 24.0) { v = s24 } else { 0.0 }
    if (idx == 25.0) { v = s25 } else { 0.0 }
    if (idx == 26.0) { v = s26 } else { 0.0 }
    if (idx == 27.0) { v = s27 } else { 0.0 }
    if (idx == 28.0) { v = s28 } else { 0.0 }
    if (idx == 29.0) { v = s29 } else { 0.0 }
    if (idx == 30.0) { v = s30 } else { 0.0 }
    if (idx == 31.0) { v = s31 } else { 0.0 }
    if (idx == 32.0) { v = s32 } else { 0.0 }
    if (idx == 33.0) { v = s33 } else { 0.0 }
    if (idx == 34.0) { v = s34 } else { 0.0 }
    if (idx == 35.0) { v = s35 } else { 0.0 }
    v
}

sudoku_count_digit(k) = {
    c = 0.0
    if (s0 == k) { c = c + 1.0 } else { 0.0 }
    if (s1 == k) { c = c + 1.0 } else { 0.0 }
    if (s2 == k) { c = c + 1.0 } else { 0.0 }
    if (s3 == k) { c = c + 1.0 } else { 0.0 }
    if (s4 == k) { c = c + 1.0 } else { 0.0 }
    if (s5 == k) { c = c + 1.0 } else { 0.0 }
    if (s6 == k) { c = c + 1.0 } else { 0.0 }
    if (s7 == k) { c = c + 1.0 } else { 0.0 }
    if (s8 == k) { c = c + 1.0 } else { 0.0 }
    if (s9 == k) { c = c + 1.0 } else { 0.0 }
    if (s10 == k) { c = c + 1.0 } else { 0.0 }
    if (s11 == k) { c = c + 1.0 } else { 0.0 }
    if (s12 == k) { c = c + 1.0 } else { 0.0 }
    if (s13 == k) { c = c + 1.0 } else { 0.0 }
    if (s14 == k) { c = c + 1.0 } else { 0.0 }
    if (s15 == k) { c = c + 1.0 } else { 0.0 }
    if (s16 == k) { c = c + 1.0 } else { 0.0 }
    if (s17 == k) { c = c + 1.0 } else { 0.0 }
    if (s18 == k) { c = c + 1.0 } else { 0.0 }
    if (s19 == k) { c = c + 1.0 } else { 0.0 }
    if (s20 == k) { c = c + 1.0 } else { 0.0 }
    if (s21 == k) { c = c + 1.0 } else { 0.0 }
    if (s22 == k) { c = c + 1.0 } else { 0.0 }
    if (s23 == k) { c = c + 1.0 } else { 0.0 }
    if (s24 == k) { c = c + 1.0 } else { 0.0 }
    if (s25 == k) { c = c + 1.0 } else { 0.0 }
    if (s26 == k) { c = c + 1.0 } else { 0.0 }
    if (s27 == k) { c = c + 1.0 } else { 0.0 }
    if (s28 == k) { c = c + 1.0 } else { 0.0 }
    if (s29 == k) { c = c + 1.0 } else { 0.0 }
    if (s30 == k) { c = c + 1.0 } else { 0.0 }
    if (s31 == k) { c = c + 1.0 } else { 0.0 }
    if (s32 == k) { c = c + 1.0 } else { 0.0 }
    if (s33 == k) { c = c + 1.0 } else { 0.0 }
    if (s34 == k) { c = c + 1.0 } else { 0.0 }
    if (s35 == k) { c = c + 1.0 } else { 0.0 }
    c
}

sudoku_set_cell(idx, val) = {
    if (s_won == 0.0) {
        if (idx == 1.0) { s1 = val } else { 0.0 }
        if (idx == 3.0) { s3 = val } else { 0.0 }
        if (idx == 5.0) { s5 = val } else { 0.0 }
        if (idx == 6.0) { s6 = val } else { 0.0 }
        if (idx == 8.0) { s8 = val } else { 0.0 }
        if (idx == 10.0) { s10 = val } else { 0.0 }
        if (idx == 11.0) { s11 = val } else { 0.0 }
        if (idx == 13.0) { s13 = val } else { 0.0 }
        if (idx == 14.0) { s14 = val } else { 0.0 }
        if (idx == 16.0) { s16 = val } else { 0.0 }
        if (idx == 18.0) { s18 = val } else { 0.0 }
        if (idx == 20.0) { s20 = val } else { 0.0 }
        if (idx == 21.0) { s21 = val } else { 0.0 }
        if (idx == 23.0) { s23 = val } else { 0.0 }
        if (idx == 24.0) { s24 = val } else { 0.0 }
        if (idx == 26.0) { s26 = val } else { 0.0 }
        if (idx == 28.0) { s28 = val } else { 0.0 }
        if (idx == 31.0) { s31 = val } else { 0.0 }
        if (idx == 32.0) { s32 = val } else { 0.0 }
        if (idx == 33.0) { s33 = val } else { 0.0 }
        if (idx == 35.0) { s35 = val } else { 0.0 }
        s_msg = 0.0
    } else { 0.0 }
    1.0
}

sudoku_reset_board() = {
    s1 = 0.0
    s3 = 0.0
    s5 = 0.0
    s6 = 0.0
    s8 = 0.0
    s10 = 0.0
    s11 = 0.0
    s13 = 0.0
    s14 = 0.0
    s16 = 0.0
    s18 = 0.0
    s20 = 0.0
    s21 = 0.0
    s23 = 0.0
    s24 = 0.0
    s26 = 0.0
    s28 = 0.0
    s31 = 0.0
    s32 = 0.0
    s33 = 0.0
    s35 = 0.0
    s_sel = 1.0
    s_sel_val = 0.0
    s_msg = 0.0
    s_won = 0.0
    s_frames = 0.0
    1.0
}

// Verifica si 6 celdas forman {1..6} (suma = 21 y producto = 720)
sudoku_group_ok(a, b, c, d, e, f) = {
    ok = 0.0
    sm = a + b + c + d + e + f
    pr = a * b * c * d * e * f
    if (sm == 21.0) {
        if (pr == 720.0) {
            ok = 1.0
        } else { 0.0 }
    } else { 0.0 }
    ok
}

sudoku_validate_all() = {
    tot = 0.0
    tot = tot + sudoku_group_ok(s0, s1, s2, s3, s4, s5)
    tot = tot + sudoku_group_ok(s6, s7, s8, s9, s10, s11)
    tot = tot + sudoku_group_ok(s12, s13, s14, s15, s16, s17)
    tot = tot + sudoku_group_ok(s18, s19, s20, s21, s22, s23)
    tot = tot + sudoku_group_ok(s24, s25, s26, s27, s28, s29)
    tot = tot + sudoku_group_ok(s30, s31, s32, s33, s34, s35)

    tot = tot + sudoku_group_ok(s0, s6, s12, s18, s24, s30)
    tot = tot + sudoku_group_ok(s1, s7, s13, s19, s25, s31)
    tot = tot + sudoku_group_ok(s2, s8, s14, s20, s26, s32)
    tot = tot + sudoku_group_ok(s3, s9, s15, s21, s27, s33)
    tot = tot + sudoku_group_ok(s4, s10, s16, s22, s28, s34)
    tot = tot + sudoku_group_ok(s5, s11, s17, s23, s29, s35)

    tot = tot + sudoku_group_ok(s0, s1, s2, s6, s7, s8)
    tot = tot + sudoku_group_ok(s3, s4, s5, s9, s10, s11)
    tot = tot + sudoku_group_ok(s12, s13, s14, s18, s19, s20)
    tot = tot + sudoku_group_ok(s15, s16, s17, s21, s22, s23)
    tot = tot + sudoku_group_ok(s24, s25, s26, s30, s31, s32)
    tot = tot + sudoku_group_ok(s27, s28, s29, s33, s34, s35)

    ok = 0.0
    if (tot == 18.0) {
        s_msg = 1.0
        ok = 1.0
    } else {
        s_msg = 2.0
    }
    ok
}

// Dibuja cada celda con guía de fila/col/caja, igual número y conflicto en rojo
sudoku_draw_cell(idx, val) = {
    col = idx % 6.0
    row = (idx - col) / 6.0
    scol = s_sel % 6.0
    srow = (s_sel - scol) / 6.0

    b_c = (col - (col % 3.0)) / 3.0
    b_r = (row - (row % 2.0)) / 2.0
    sb_c = (scol - (scol % 3.0)) / 3.0
    sb_r = (srow - (srow % 2.0)) / 2.0

    same_box = 0.0
    if (b_c == sb_c) {
        if (b_r == sb_r) { same_box = 1.0 } else { 0.0 }
    } else { 0.0 }

    same_peer = 0.0
    if (col == scol) { same_peer = 1.0 } else { 0.0 }
    if (row == srow) { same_peer = 1.0 } else { 0.0 }
    if (same_box == 1.0) { same_peer = 1.0 } else { 0.0 }

    conflict = 0.0
    if (idx != s_sel) {
        if (val > 0.0) {
            if (val == s_sel_val) {
                if (same_peer == 1.0) { conflict = 1.0 } else { 0.0 }
            } else { 0.0 }
        } else { 0.0 }
    } else { 0.0 }

    cx = s_gx + (col * s_cell)
    cy = s_gy + (row * s_cell)
    fx = sudoku_is_fixed(idx)

    bg = 0x0D1117
    if (fx == 1.0) { bg = 0x131922 } else { 0.0 }
    if (same_peer == 1.0) { bg = 0x152030 } else { 0.0 }
    if (val > 0.0) {
        if (val == s_sel_val) { bg = 0x17322A } else { 0.0 }
    } else { 0.0 }
    if (s_sel == idx) { bg = 0x1F3B5C } else { 0.0 }
    if (conflict == 1.0) { bg = 0x4A1D24 } else { 0.0 }

    rect(cx + 1.0, cy + 1.0, s_cell - 2.0, s_cell - 2.0, bg)

    if (val > 0.0) {
        col_hex = 0x3FB950
        if (fx == 1.0) { col_hex = 0x58A6FF } else { 0.0 }
        if (conflict == 1.0) { col_hex = 0xF85149 } else { 0.0 }
        text_num(val, cx + (s_cell * 0.36), cy + (s_cell * 0.28), 18.0, col_hex)
    } else { 0.0 }
    1.0
}

sudoku_draw_all_cells() = {
    sudoku_draw_cell(0.0, s0)
    sudoku_draw_cell(1.0, s1)
    sudoku_draw_cell(2.0, s2)
    sudoku_draw_cell(3.0, s3)
    sudoku_draw_cell(4.0, s4)
    sudoku_draw_cell(5.0, s5)
    sudoku_draw_cell(6.0, s6)
    sudoku_draw_cell(7.0, s7)
    sudoku_draw_cell(8.0, s8)
    sudoku_draw_cell(9.0, s9)
    sudoku_draw_cell(10.0, s10)
    sudoku_draw_cell(11.0, s11)
    sudoku_draw_cell(12.0, s12)
    sudoku_draw_cell(13.0, s13)
    sudoku_draw_cell(14.0, s14)
    sudoku_draw_cell(15.0, s15)
    sudoku_draw_cell(16.0, s16)
    sudoku_draw_cell(17.0, s17)
    sudoku_draw_cell(18.0, s18)
    sudoku_draw_cell(19.0, s19)
    sudoku_draw_cell(20.0, s20)
    sudoku_draw_cell(21.0, s21)
    sudoku_draw_cell(22.0, s22)
    sudoku_draw_cell(23.0, s23)
    sudoku_draw_cell(24.0, s24)
    sudoku_draw_cell(25.0, s25)
    sudoku_draw_cell(26.0, s26)
    sudoku_draw_cell(27.0, s27)
    sudoku_draw_cell(28.0, s28)
    sudoku_draw_cell(29.0, s29)
    sudoku_draw_cell(30.0, s30)
    sudoku_draw_cell(31.0, s31)
    sudoku_draw_cell(32.0, s32)
    sudoku_draw_cell(33.0, s33)
    sudoku_draw_cell(34.0, s34)
    sudoku_draw_cell(35.0, s35)
    1.0
}

sudoku_draw_keypad(px, py, clicked) = {
    ky = s_gy + s_bw + 14.0
    kw = (s_bw - 24.0) / 7.0
    kh = 42.0
    k = 1.0
    while (k <= 6.0) {
        kx = s_gx + ((k - 1.0) * (kw + 4.0))
        cnt = sudoku_count_digit(k)
        kbg = 0x161B22
        kfg = 0xE6EDF3
        kbr = 0x30363D
        if (cnt >= 6.0) {
            kbg = 0x0D1914
            kfg = 0x3FB950
            kbr = 0x238636
        } else { 0.0 }

        rect(kx, ky, kw, kh, kbg)
        line(kx, ky, kx + kw, ky, kbr)
        line(kx, ky + kh, kx + kw, ky + kh, kbr)
        line(kx, ky, kx, ky + kh, kbr)
        line(kx + kw, ky, kx + kw, ky + kh, kbr)
        text_num(k, kx + (kw * 0.36), ky + 12.0, 15.0, kfg)

        if (clicked == 1.0) {
            if (hit_rect(px, py, kx, ky, kw, kh) == 1.0) {
                if (s_sel >= 0.0) {
                    if (sudoku_is_fixed(s_sel) == 0.0) {
                        sudoku_set_cell(s_sel, k)
                    } else { 0.0 }
                } else { 0.0 }
            } else { 0.0 }
        } else { 0.0 }
        k = k + 1.0
    }

    bx = s_gx + (6.0 * (kw + 4.0))
    draw_btn(bx, ky, kw, kh, 0x21262D, 0xF85149, "X", bx + (kw * 0.34), ky + 14.0, 0xF85149)
    if (clicked == 1.0) {
        if (hit_rect(px, py, bx, ky, kw, kh) == 1.0) {
            if (s_sel >= 0.0) {
                if (sudoku_is_fixed(s_sel) == 0.0) {
                    sudoku_set_cell(s_sel, 0.0)
                } else { 0.0 }
            } else { 0.0 }
        } else { 0.0 }
    } else { 0.0 }
    1.0
}

render_mini_sudoku(sw, sh, px, py, clicked) = {
    earned = 0.0
    s_bw = grid_board_w(sw, 12.0, 420.0)
    s_gx = grid_origin_x(sw, s_bw)
    s_gy = 104.0
    s_cell = s_bw / 6.0

    if (s_won == 0.0) {
        s_frames = s_frames + 1.0
    } else { 0.0 }
    secs = (s_frames - (s_frames % 60.0)) / 60.0

    s_sel_val = sudoku_get_val(s_sel)

    text("MINI SUDOKU 6x6", s_gx, 60.0, 13.0, 0x3FB950)
    text("TIEMPO:", s_gx + s_bw - 92.0, 62.0, 9.5, 0x8B949E)
    text_num(secs, s_gx + s_bw - 34.0, 61.0, 10.5, 0x79C0FF)

    if (s_msg == 1.0) {
        text("PERFECTO! SUDOKU 6x6 RESUELTO", s_gx, 80.0, 9.5, 0x3FB950)
    } else {
        if (s_msg == 2.0) {
            text("REVISA: FALTAN O SE REPITEN NUMEROS", s_gx, 80.0, 9.5, 0xF85149)
        } else {
            text("Cajas 2x3 — Conflictos en rojo al instante", s_gx, 80.0, 9.5, 0x8B949E)
        }
    }

    grid_draw(s_gx, s_gy, 6.0, 6.0, s_cell, 0x0D1117, 0x30363D, 0x58A6FF)
    sudoku_draw_all_cells()
    grid_draw_subboxes(s_gx, s_gy, 6.0, 6.0, 3.0, 2.0, s_cell, 0x58A6FF)

    sudoku_draw_keypad(px, py, clicked)

    ay = s_gy + s_bw + 68.0
    aw = (s_bw - 10.0) * 0.5
    draw_btn(s_gx, ay, aw, 40.0, 0x238636, 0x2EA043, "VALIDAR", s_gx + 14.0, ay + 14.0, 0xFFFFFF)
    draw_btn(s_gx + aw + 10.0, ay, aw, 40.0, 0x21262D, 0x30363D, "REINICIAR", s_gx + aw + 24.0, ay + 14.0, 0xE6EDF3)

    if (clicked == 1.0) {
        hit_i = grid_hit_index(px, py, s_gx, s_gy, 6.0, 6.0, s_cell)
        if (hit_i >= 0.0) {
            s_sel = hit_i
        } else {
            if (hit_rect(px, py, s_gx, ay, aw, 40.0) == 1.0) {
                if (sudoku_validate_all() == 1.0) {
                    if (s_won == 0.0) {
                        s_won = 1.0
                        earned = 50.0
                    } else { 0.0 }
                } else { 0.0 }
            } else {
                if (hit_rect(px, py, s_gx + aw + 10.0, ay, aw, 40.0) == 1.0) {
                    sudoku_reset_board()
                } else { 0.0 }
            }
        }
    } else { 0.0 }
    earned
}
