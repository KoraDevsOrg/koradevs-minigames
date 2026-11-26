// ============================================================================
// MINI SUDOKU 6x6 (CAJAS 2x3) — MEMORIA PLANA SoA + POPUP DE VICTORIA Y SCORE
// Arena: base 0.0 = tablero (36 celdas) | base 64.0 = pistas fijas (36 celdas)
// ============================================================================
signal s_init = 0.0
signal s_level = 1.0
signal s_last_diff = 1.0
signal s_sel = 0.0
signal s_sel_val = 0.0
signal s_msg = 0.0
signal s_won = 0.0
signal s_val_count = 0.0
signal s_popup = 0.0
signal s_errors = 0.0
signal s_last_score = 0.0
signal s_tick = 0.0
signal s_secs = 0.0
signal s_gx = 12.0
signal s_gy = 108.0
signal s_cell = 56.0
signal s_bw = 336.0

sudoku_calc_score(diff, secs, err_cnt) = {
    base_pts = 100.0
    if (diff == 2.0) { base_pts = 200.0 } else { 0.0 }
    if (diff >= 3.0) { base_pts = 300.0 } else { 0.0 }

    pen_time = secs
    if (pen_time > (base_pts * 0.5)) {
        pen_time = base_pts * 0.5
    } else { 0.0 }

    pen_err = err_cnt * 15.0
    final_pts = base_pts - pen_time - pen_err
    if (final_pts < 25.0) {
        final_pts = 25.0
    } else { 0.0 }
    final_pts
}

sudoku_load_level(lvl, diff) = {
    clue_cut = 6.0
    if (diff == 2.0) { clue_cut = 5.0 } else { 0.0 }
    if (diff >= 3.0) { clue_cut = 4.0 } else { 0.0 }

    i = 0.0
    first_free = 0.0 - 1.0
    while (i < 36.0) {
        col = i % 6.0
        row = (i - col) / 6.0
        rr = row
        cc = col
        if ((lvl % 2.0) == 0.0) { cc = 5.0 - col } else { 0.0 }
        if ((lvl % 3.0) == 0.0) { rr = 5.0 - row } else { 0.0 }

        br = (rr - (rr % 2.0)) / 2.0
        lr = rr % 2.0
        bc = (cc - (cc % 3.0)) / 3.0
        lc = cc % 3.0

        v = (((bc + lr) % 2.0) * 3.0) + ((lc + br) % 3.0) + 1.0
        v = ((v + lvl) % 6.0) + 1.0

        h = ((row * 7.0) + (col * 13.0) + (lvl * 17.0)) % 11.0
        if (h < clue_cut) {
            mem_set(0.0, i, v)
            mem_set(64.0, i, 1.0)
        } else {
            mem_set(0.0, i, 0.0)
            mem_set(64.0, i, 0.0)
            if (first_free < 0.0) { first_free = i } else { 0.0 }
        }
        i = i + 1.0
    }
    if (first_free < 0.0) { first_free = 0.0 } else { 0.0 }
    s_sel = first_free
    s_sel_val = 0.0
    s_msg = 0.0
    s_won = 0.0
    s_popup = 0.0
    s_errors = 0.0
    s_last_score = 0.0
    s_tick = 0.0
    s_secs = 0.0
    1.0
}

sudoku_reset_board() = {
    i = 0.0
    while (i < 36.0) {
        if (mem_get(64.0, i) == 0.0) {
            mem_set(0.0, i, 0.0)
        } else { 0.0 }
        i = i + 1.0
    }
    s_msg = 0.0
    s_won = 0.0
    s_popup = 0.0
    s_errors = 0.0
    s_last_score = 0.0
    s_tick = 0.0
    s_secs = 0.0
    1.0
}

sudoku_validate_all() = {
    tot = 0.0

    r = 0.0
    while (r < 6.0) {
        sm = 0.0
        pr = 1.0
        c = 0.0
        while (c < 6.0) {
            v = mem_get(0.0, (r * 6.0) + c)
            sm = sm + v
            pr = pr * v
            c = c + 1.0
        }
        if (sm == 21.0) {
            if (pr == 720.0) { tot = tot + 1.0 } else { 0.0 }
        } else { 0.0 }
        r = r + 1.0
    }

    c = 0.0
    while (c < 6.0) {
        sm = 0.0
        pr = 1.0
        r = 0.0
        while (r < 6.0) {
            v = mem_get(0.0, (r * 6.0) + c)
            sm = sm + v
            pr = pr * v
            r = r + 1.0
        }
        if (sm == 21.0) {
            if (pr == 720.0) { tot = tot + 1.0 } else { 0.0 }
        } else { 0.0 }
        c = c + 1.0
    }

    br = 0.0
    while (br < 3.0) {
        bc = 0.0
        while (bc < 2.0) {
            sm = 0.0
            pr = 1.0
            lr = 0.0
            while (lr < 2.0) {
                lc = 0.0
                while (lc < 3.0) {
                    idx = (((br * 2.0) + lr) * 6.0) + ((bc * 3.0) + lc)
                    v = mem_get(0.0, idx)
                    sm = sm + v
                    pr = pr * v
                    lc = lc + 1.0
                }
                lr = lr + 1.0
            }
            if (sm == 21.0) {
                if (pr == 720.0) { tot = tot + 1.0 } else { 0.0 }
            } else { 0.0 }
            bc = bc + 1.0
        }
        br = br + 1.0
    }

    ok = 0.0
    if (tot == 18.0) {
        s_msg = 1.0
        ok = 1.0
    } else {
        s_msg = 2.0
        s_errors = s_errors + 1.0
    }
    ok
}

sudoku_draw_all_cells() = {
    scol = s_sel % 6.0
    srow = (s_sel - scol) / 6.0
    sb_c = (scol - (scol % 3.0)) / 3.0
    sb_r = (srow - (srow % 2.0)) / 2.0

    idx = 0.0
    while (idx < 36.0) {
        val = mem_get(0.0, idx)
        fx = mem_get(64.0, idx)
        col = idx % 6.0
        row = (idx - col) / 6.0
        b_c = (col - (col % 3.0)) / 3.0
        b_r = (row - (row % 2.0)) / 2.0

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

        idx = idx + 1.0
    }
    1.0
}

sudoku_draw_keypad(px, py, clicked) = {
    ky = s_gy + s_bw + 14.0
    kw = (s_bw - 24.0) / 7.0
    kh = 42.0
    k = 1.0
    while (k <= 6.0) {
        kx = s_gx + ((k - 1.0) * (kw + 4.0))
        cnt = mem_count(0.0, 36.0, k)
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
                if (s_won == 0.0) {
                    if (mem_get(64.0, s_sel) == 0.0) {
                        mem_set(0.0, s_sel, k)
                        s_msg = 0.0
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
            if (s_won == 0.0) {
                if (mem_get(64.0, s_sel) == 0.0) {
                    mem_set(0.0, s_sel, 0.0)
                    s_msg = 0.0
                } else { 0.0 }
            } else { 0.0 }
        } else { 0.0 }
    } else { 0.0 }
    1.0
}

// Dibuja el popup de ganador y gestiona sus botones [SIGUIENTE] y [CERRAR]
sudoku_render_win_popup(sw, sh, px, py, clicked) = {
    act = 0.0
    if (s_popup == 1.0) {
        pw = s_bw - 20.0
        ph = 228.0
        px0 = s_gx + 10.0
        py0 = s_gy + 52.0

        rect(px0, py0, pw, ph, 0x161B22)
        line(px0, py0, px0 + pw, py0, 0x3FB950)
        line(px0, py0 + ph, px0 + pw, py0 + ph, 0x3FB950)
        line(px0, py0, px0, py0 + ph, 0x3FB950)
        line(px0 + pw, py0, px0 + pw, py0 + ph, 0x3FB950)

        text("GANASTE! SUDOKU RESUELTO", px0 + 14.0, py0 + 16.0, 12.0, 0x3FB950)

        text("SCORE:", px0 + 16.0, py0 + 50.0, 11.0, 0x8B949E)
        text_num(s_last_score, px0 + 92.0, py0 + 49.0, 14.0, 0xD29922)

        text("TIEMPO (s):", px0 + 16.0, py0 + 84.0, 10.0, 0x8B949E)
        text_num(s_secs, px0 + 124.0, py0 + 83.0, 11.5, 0x79C0FF)

        text("ERRORES:", px0 + 16.0, py0 + 110.0, 10.0, 0x8B949E)
        text_num(s_errors, px0 + 124.0, py0 + 109.0, 11.5, 0xF85149)

        text("-1 pt/seg y -15 pts/error", px0 + 16.0, py0 + 138.0, 9.5, 0x8B949E)

        by = py0 + 170.0
        bw_btn = (pw - 36.0) * 0.5
        bx_next = px0 + 12.0
        bx_cls = px0 + 24.0 + bw_btn

        draw_btn(bx_next, by, bw_btn, 40.0, 0x238636, 0x2EA043, "SIGUIENTE", bx_next + 10.0, by + 14.0, 0xFFFFFF)
        draw_btn(bx_cls, by, bw_btn, 40.0, 0x21262D, 0x30363D, "CERRAR", bx_cls + 18.0, by + 14.0, 0xE6EDF3)

        if (clicked == 1.0) {
            if (hit_rect(px, py, bx_next, by, bw_btn, 40.0) == 1.0) {
                act = 1.0
            } else {
                if (hit_rect(px, py, bx_cls, by, bw_btn, 40.0) == 1.0) {
                    act = 2.0
                } else { 0.0 }
            }
        } else { 0.0 }
    } else { 0.0 }
    act
}

sudoku_on_validate() = {
    res_pts = 0.0
    if (sudoku_validate_all() == 1.0) {
        if (s_won == 0.0) {
            s_won = 1.0
            s_popup = 1.0
            s_last_score = sudoku_calc_score(difficulty, s_secs, s_errors)
            res_pts = s_last_score
        } else {
            s_popup = 1.0
        }
    } else { 0.0 }
    res_pts
}

render_mini_sudoku(sw, sh, px, py, clicked) = {
    earned = 0.0
    if (s_init == 0.0) {
        s_init = 1.0
        s_last_diff = difficulty
        s_val_count = 0.0
        sudoku_load_level(s_level, difficulty)
    } else {
        if (s_last_diff != difficulty) {
            s_last_diff = difficulty
            s_val_count = 0.0
            sudoku_load_level(s_level, difficulty)
        } else { 0.0 }
    }

    s_bw = grid_board_w(sw, 12.0, 420.0)
    s_gx = grid_origin_x(sw, s_bw)
    s_gy = 108.0
    s_cell = s_bw / 6.0

    if (s_won == 0.0) {
        s_tick = s_tick + 1.0
        if (s_tick >= 60.0) {
            s_tick = 0.0
            s_secs = s_secs + 1.0
        } else { 0.0 }
    } else { 0.0 }
    s_sel_val = mem_get(0.0, s_sel)

    ny = 56.0
    draw_btn(s_gx, ny, 32.0, 26.0, 0x21262D, 0x30363D, "<", s_gx + 11.0, ny + 7.0, 0xE6EDF3)
    text("SUDOKU #", s_gx + 38.0, ny + 7.0, 11.5, 0x3FB950)
    text_num(s_level, s_gx + 104.0, ny + 7.0, 11.5, 0x3FB950)
    draw_btn(s_gx + 132.0, ny, 32.0, 26.0, 0x21262D, 0x30363D, ">", s_gx + 143.0, ny + 7.0, 0xE6EDF3)
    draw_btn(s_gx + 168.0, ny, 38.0, 26.0, 0x1F2937, 0x58A6FF, "+5", s_gx + 177.0, ny + 7.0, 0x58A6FF)

    text("T:", s_gx + s_bw - 56.0, ny + 7.0, 10.0, 0x8B949E)
    text_num(s_secs, s_gx + s_bw - 38.0, ny + 6.0, 11.0, 0x79C0FF)

    if (s_msg == 1.0) {
        text("GANASTE! SCORE:", s_gx, 88.0, 9.5, 0x3FB950)
        text_num(s_last_score, s_gx + 124.0, 87.0, 10.5, 0xD29922)
    } else {
        if (s_msg == 2.0) {
            text("REVISA — ERR:", s_gx, 88.0, 9.5, 0xF85149)
            text_num(s_errors, s_gx + 112.0, 87.0, 10.5, 0xF85149)
            text("CHK:", s_gx + 146.0, 88.0, 9.5, 0x8B949E)
            text_num(s_val_count, s_gx + 182.0, 87.0, 10.5, 0x79C0FF)
        } else {
            text("CHK:", s_gx, 88.0, 9.5, 0x8B949E)
            text_num(s_val_count, s_gx + 36.0, 87.0, 10.5, 0x79C0FF)
            if (difficulty == 1.0) {
                text("FACIL — Conflictos en rojo", s_gx + 64.0, 88.0, 9.5, 0x8B949E)
            } else {
                if (difficulty == 2.0) {
                    text("MEDIA — Conflictos en rojo", s_gx + 64.0, 88.0, 9.5, 0xD29922)
                } else {
                    text("DIFICIL — Conflictos en rojo", s_gx + 64.0, 88.0, 9.5, 0xF85149)
                }
            }
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
        if (s_popup == 1.0) {
            pw = s_bw - 20.0
            ph = 228.0
            px0 = s_gx + 10.0
            py0 = s_gy + 52.0
            by = py0 + 170.0
            bw_btn = (pw - 36.0) * 0.5
            bx_next = px0 + 12.0
            bx_cls = px0 + 24.0 + bw_btn

            if (hit_rect(px, py, bx_next, by, bw_btn, 40.0) == 1.0) {
                s_level = s_level + 1.0
                s_val_count = 0.0
                sudoku_load_level(s_level, difficulty)
            } else {
                if (hit_rect(px, py, bx_cls, by, bw_btn, 40.0) == 1.0) {
                    s_popup = 0.0
                } else { 0.0 }
            }
        } else {
            if (hit_rect(px, py, s_gx, ay, aw, 40.0) == 1.0) {
                s_val_count = s_val_count + 1.0
                earned = sudoku_on_validate()
            } else {
                if (hit_rect(px, py, s_gx + aw + 10.0, ay, aw, 40.0) == 1.0) {
                    s_val_count = 0.0
                    sudoku_reset_board()
                } else {
                    if (hit_rect(px, py, s_gx, ny, 32.0, 26.0) == 1.0) {
                        if (s_level > 1.0) {
                            s_level = s_level - 1.0
                            s_val_count = 0.0
                            sudoku_load_level(s_level, difficulty)
                        } else { 0.0 }
                    } else {
                        if (hit_rect(px, py, s_gx + 132.0, ny, 32.0, 26.0) == 1.0) {
                            s_level = s_level + 1.0
                            s_val_count = 0.0
                            sudoku_load_level(s_level, difficulty)
                        } else {
                            if (hit_rect(px, py, s_gx + 168.0, ny, 38.0, 26.0) == 1.0) {
                                s_level = s_level + 5.0
                                s_val_count = 0.0
                                sudoku_load_level(s_level, difficulty)
                            } else {
                                hit_i = grid_hit_index(px, py, s_gx, s_gy, 6.0, 6.0, s_cell)
                                if (hit_i >= 0.0) {
                                    s_sel = hit_i
                                } else { 0.0 }
                            }
                        }
                    }
                }
            }
        }
    } else { 0.0 }

    if (s_popup == 1.0) {
        sudoku_render_win_popup(sw, sh, px, py, 0.0)
    } else { 0.0 }

    earned
}
