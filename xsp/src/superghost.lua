require "util"
require "func"

-- 超鬼王Global
sg_en = 0
sg_keep = 0 -- 超鬼王独立portal进入时使脚本持续运行
sg_fight_sel = nil -- 自己发现的/所有公开的
sg_mark_sel = {0, 0}
sg_force = 0 -- 强力追击
sg_tired = {0, 0, 0, 0, 0, 0} -- 疲劳操作
sg_high = {0, 0, 0, 0, 0, 0} -- 高血量操作
sg_low = {0, 0, 0, 0, 0, 0} -- 低血量操作

-- Def
-- 3个横排区域中心勾玉范围 x1,y1,x2,y2
mgt_find_x1 = {115, 115, 115}
mgt_find_y1 = {310, 425, 540}
mgt_find_x2 = {135, 135, 135}
mgt_find_y2 = {320, 435, 550}
-- 3个横排区域50%找色范围
target_bar_50_x1 = {269, 269, 269}
target_bar_50_y1 = {329, 444, 559}
target_bar_50_x2 = {271, 271, 271}
target_bar_50_y2 = {331, 446, 561}

-- Util func
function lct_sg_window()
	-- 识别弹窗
	local x = -1
	local y = -1
	
	if ver == "iOS" then
		x, y = findColor({24, 200, 26, 450}, -- 弹窗箭头
			"0|0|0xcf8d43,26|1|0x846e5c,273|-10|0xd3755c,354|-75|0x13100e,407|-30|0xe1dad1",
			95, 0, 0, 0)
		if x > -1 then
			HUD_show_or_hide(HUD,hud_info,"发现超鬼王",20,"0xff000000","0xffffffff",0,100,0,300,32)
			random_touch(0, x + 200, y, 50, 20) -- 点击弹窗
			return x, y
		end
		return x, y
	end
	
	if ver == "android" then
		x, y = findColor({24, 200, 26, 450}, -- 弹窗箭头
			"0|0|0xcd8b40,23|1|0xb4a593,352|-75|0x121210,403|-9|0xdfd7ce,268|-11|0xd57259",
			95, 0, 0, 0)
		if x > -1 then
			HUD_show_or_hide(HUD,hud_info,"发现超鬼王",20,"0xff000000","0xffffffff",0,100,0,300,32)
			random_touch(0, x + 200, y, 50, 20) -- 点击弹窗
			return x, y
		end
		return x, y
	end
	return x, y
end

function lct_sg_page()
	-- 识别超鬼王页面
	local x, y = findColor({922, 9, 924, 11},
		"0|0|0xc4dbed,-492|19|0x47211f,-542|126|0xcd9f45,-869|47|0xf0f5fb",
		95, 0, 0, 0)
	return x, y
end

function lct_sg_group()
	-- 识别集结页面
	local x, y = findColor({844, 57, 846, 59},
		"0|0|0xf6dfd8,-573|12|0xe2758c,-408|-32|0x1c0c0c,27|483|0x625641,-791|-3|0x636567",
		95, 0, 0, 0)
	return x, y
end

function find_sg_6(index)
	-- 识别6星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf49e33,33|0|0xf49d32,-22|0|0xf49e33,-16|25|0xf8f3e0,224|-55|0xa79894,224|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_5(index)
	-- 识别5星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf5a332,22|0|0xf5a433,-22|0|0xf5a432,-22|25|0xf8f3e0,218|-55|0xa79894,218|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_4(index)
	-- 识别4星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf49e33,22|0|0xf49d32,-11|0|0xf49e33,-16|25|0xf8f3e0,224|-55|0xa79894,224|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_3(index)
	-- 识别3星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf5a332,11|0|0xf5a432,-11|0|0xf5a432,-22|25|0xf8f3e0,218|-55|0xa79894,218|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_2(index)
	-- 识别2星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf49e33,11|0|0xf49e33,224|-55|0xa79894,224|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_1(index)
	-- 识别1星
	local x, y = findColor({mgt_find_x1[index], mgt_find_y1[index], mgt_find_x2[index], mgt_find_y2[index]},
		"0|0|0xf5a332,-1|1|0xf69f31,218|-55|0xa79894,218|5|0xa79894",
		95, 0, 0, 0)
	return x, y
end

function find_sg_mgt(index)
	-- 识别当前区域星级
	local x = -1
	local y = -1
	x, y = find_sg_6(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现6星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 6
	end
	x, y = find_sg_5(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现5星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 5
	end
	x, y = find_sg_4(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现4星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 4
	end
	x, y = find_sg_3(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现3星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 3
	end
	x, y = find_sg_2(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现2星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 2
	end
	x, y = find_sg_1(index)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,string.format("区域%d发现1星鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return x, y, 1
	end
	return x, y, 0
end

function find_sg_50(index)
	-- 识别50%刻度血条
	local x, y = findColor({target_bar_50_x1[index], target_bar_50_y1[index], target_bar_50_x2[index], target_bar_50_y2[index]},
		"0|0|0xe35f30,-100|-15|0xa89a96,185|-15|0xa69793",
		95, 0, 0, 0)
	if x > -1 then
		return RET_OK
	end
	return RET_ERR
end

function find_sg_tb(index, sg_curr)
	-- 判断高/低血量, 返回操作string
	local ret_50
	ret_50 = find_sg_50(index)
	
	if ret_50 == RET_OK then
		HUD_show_or_hide(HUD,hud_info,string.format("高血量 - 执行 %s", sg_high[sg_curr]),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return sg_high[sg_curr]
	else
		HUD_show_or_hide(HUD,hud_info,string.format("低血量 - 执行 %s", sg_low[sg_curr]),20,"0xff000000","0xffffffff",0,100,0,300,32)
		return sg_low[sg_curr]
	end
	return nil
end

function sg_mark(last_mark)
	-- 标记Boss&草人
	local cnt = math.random(1, 2)
	local x, y, x_, y_
	if sg_mark_sel[1] == 0 and sg_mark_sel[2] == 0 then
		return nil
	end
	if sg_mark_sel[1] == 1 and sg_mark_sel[2] == 0 then
		if last_mark ~= "Boss" then
			for i = 1, cnt do
				random_sleep(250)
				random_touch(0, 530, 100, 5, 5) -- 标记boss
			end
		end
		return "Boss"
	elseif sg_mark_sel[1] == 0 and sg_mark_sel[2] == 1 then
		x, y = findColor({600, 190, 605, 220}, -- 丑女血条
			"0|0|0xaf0d0a,2|0|0xb10e0b,4|0|0xb30e0b,-569|-168|0xd6c4a1,-582|-176|0x211b0f",
			80, 0, 0, 0)
		if x > -1 then
			x_, y_ = findColor({610, 140, 660, 170}, -- 箭头
				"0|0|0xd41635,-7|0|0xc71e43,-22|-23|0xef45aa,15|-23|0xf65db9",
				80, 0, 0, 0)
			if x_ == -1 then
				for i = 1, cnt do
					random_sleep(250)
					random_touch(0, x+20, y+80, 5, 5) -- 标记草人
				end
			end
		end
		return "草人"
	elseif sg_mark_sel[1] == 1 and sg_mark_sel[2] == 1 then
		x_, y_ = findColor({610, 140, 660, 170}, -- 箭头
			"0|0|0xd41635,-7|0|0xc71e43,-22|-23|0xef45aa,15|-23|0xf65db9",
			80, 0, 0, 0)
		if x_ > -1 then
			return "草人"
		end
		x, y = findColor({600, 190, 605, 220}, -- 丑女血条
			"0|0|0xaf0d0a,2|0|0xb10e0b,4|0|0xb30e0b,-569|-168|0xd6c4a1,-582|-176|0x211b0f",
			80, 0, 0, 0)
		if x > -1 and last_mark ~= "草人" then
			for i = 1, cnt do
				random_sleep(250)
				random_touch(0, x+20, y+80, 5, 5) -- 标记草人
			end
			return "草人"
		end
		if last_mark ~= "Boss" then
			for i = 1, cnt do
				random_sleep(250)
				random_touch(0, 530, 100, 5, 5) -- 标记boss
			end
			return "Boss"
		end
		return "草人"
	end
	return nil
end

function sg_start()
	-- 挑战识别
	local x, y = findColor({1028, 534, 1030, 536},
		"0|0|0xe5c089,-37|5|0xd1e3f1,-32|12|0xe07c52,-19|23|0xccdfee",
		95, 0, 0, 0)
	if x > -1 then
		return RET_OK
	end
	return RET_ERR
end

function sg_switch_mode(mgt)
	-- 普通追击、强力追击切换
	local x, y
	x, y = findColor({524, 499, 526, 501}, -- 普通追击
		"0|0|0xffffff,1|-16|0x4051c6,6|-7|0xfcfcfe,10|-2|0x4152c9",
		95, 0, 0, 0)
	if x > -1 then
		if mgt >= sg_force then
			random_touch(0, 705, 495, 10, 10) -- 选择强力
			return
		end
	end
	x, y = findColor({703, 499, 705, 501}, -- 强力追击
		"0|0|0xffffff,1|-16|0x4051c6,7|-7|0xfafbfd,11|-3|0x4152c8",
		95, 0, 0, 0)
	if x > -1 then
		if mgt < sg_force then
			random_touch(0, 525, 495, 10, 10) -- 选择普通
			return
		end
	end
	return
end

function sg_tired_detect()
	-- 识别疲劳窗口
	local x, y = findColor({565, 418, 568, 420},
		"0|0|0xf3b25e,-94|-92|0xecf693,-106|-96|0x8dd229,265|-247|0xe8d4cf",
		95, 0, 0, 0)
	if x > -1 then
		HUD_show_or_hide(HUD,hud_info,"疲劳溢出",20,"0xff000000","0xffffffff",0,100,0,300,32)
	end
	return x, y
end

function sg_group_check()
	-- 识别集结窗口
	local x, y = findColor({876, 554, 878, 556},
		"0|0|0xe6c385,-5|-14|0xeed29e,-19|-16|0x251717,18|-9|0xcb9354",
		80, 0, 0, 0)
	if x > -1 then
		return RET_OK
	end
	return RET_ERR
end

function sg_group_invite()
	local x, y
	-- 集結1-5位在线好友
	x, y = findColor({449, 199, 451, 201},  "0|0|0xeac7a0,0|-30|0xeac7a0,0|30|0xeac7a0,100|0|0xeac7a0,-50|0|0xebc7a0", 95, 0, 0, 0)
	if x > -1 then random_touch(0, x, y, 50, 20) random_sleep(250) end
	x, y = findColor({709, 199, 711, 201},  "0|0|0xeac7a0,0|-30|0xeac7a0,0|30|0xeac7a0,100|0|0xeac7a0,-50|0|0xebc7a0", 95, 0, 0, 0)
	if x > -1 then random_touch(0, x, y, 50, 20) random_sleep(250) end
	x, y = findColor({449, 284, 451, 286},  "0|0|0xeac7a0,0|-30|0xeac7a0,0|30|0xeac7a0,100|0|0xeac7a0,-50|0|0xebc7a0", 95, 0, 0, 0)
	if x > -1 then random_touch(0, x, y, 50, 20) random_sleep(250) end
	x, y = findColor({709, 284, 711, 286},  "0|0|0xeac7a0,0|-30|0xeac7a0,0|30|0xeac7a0,100|0|0xeac7a0,-50|0|0xebc7a0", 95, 0, 0, 0)
	if x > -1 then random_touch(0, x, y, 50, 20) random_sleep(250) end
	x, y = findColor({449, 369, 451, 371},  "0|0|0xeac7a0,0|-30|0xeac7a0,0|30|0xeac7a0,100|0|0xeac7a0,-50|0|0xebc7a0", 95, 0, 0, 0)
	if x > -1 then random_touch(0, x, y, 50, 20) random_sleep(250) end
	random_touch(0, 690, 510, 20, 10) -- 邀请
end

function sg_group_public()
	-- 5/6星鬼王公开
	random_touch(0, 450, 510, 20, 10) -- 公开
	random_sleep(500)
	random_touch(0, 670, 375, 30, 10) -- 确认
end

function sg_bonus_extra()
	-- 识别妖灵溢出
	local x, y = findColor({567, 420, 569, 422},
		"0|0|0xf3b25e,-174|-258|0xe9ab53,-166|-256|0xb54f3c,173|55|0xe9ab53,163|52|0xb34c39",
		95, 0, 0, 0)
	if x > -1 then
		random_touch(0, x, y, 30, 10)
	end
	return x, y
end

function sg_bonus_get()
	-- 识别低星鬼王自动领取奖励
	local x, y = findColor({440, 100, 445, 250},
		"0|0|0xf2e5ad,248|17|0xf2e5b4,-138|104|0xad9f9a,392|104|0xaea09b,1|258|0x500c19",
		95, 0, 0, 0)
	if x > -1 then
		right_lower_click()
	end
	return x, y
end

function sg_bonus_exit()
	-- 退出超鬼王领赏
	local x, y = findColor({991, 111, 993, 113},
		"0|0|0xe8d4cf,-877|459|0xf4d4a5,-890|446|0x281918,-756|6|0x790606",
		95, 0, 0, 0)
	if x > -1 then
		random_touch(0, x, y, 5, 5)
	end
	return x, y
end

-- Main func
function SuperGhost()
	if sg_en == 0 then
		return RET_ERR
	end
	
	local x = -1
	local y = -1
	local x_f = -1
	local y_f = -1
	local ret = 0
	local sg_curr = 0
	local sg_tb = nil
	local last_mark = nil
	local tired_op = nil
	local sg_window = 0
	local sg_page = 0
	local index = 0
	local index_max = 0
	
	-- 超鬼王弹窗/页面识别
	x, y = lct_sg_window() if x > -1 then sg_window = 1 end
	x, y = lct_sg_page() if x > -1 then sg_page = 1 end
	if (sg_window == 0) and (sg_page == 0) then
		return RET_ERR
	end
	
	-- 根据Pri/Pub设置区域扫描的循环次数
	if sg_fight_sel == "Private" then
		index_max = 1
	elseif sg_fight_sel == "Public" then
		index_max = 3
	end
	
	while (1) do
		while (1) do
			mSleep(500)
			-- 循环通用
			loop_generic()
			-- 断线结束战斗
			disconn_dur_fight()
			-- 弹窗
			x, y = lct_sg_window() if x > -1 then break end
			-- 拒绝组队
			x, y = member_team_refuse_invite() if (x > -1) then break end
			-- 战斗进行
			x, y = fight_ongoing() if (x > -1) then last_mark = sg_mark(last_mark) mSleep(3000) break end -- 三秒钟Check一次标记
			-- 疲劳溢出
			x, y = sg_tired_detect()
			if x > -1 then
				tired_op = sg_tired[sg_curr] -- 获得当前星级的疲劳操作
				if tired_op == "喝茶" then
					HUD_show_or_hide(HUD,hud_info,"购买 茶 - 58勾",20,"0xff000000","0xffffffff",0,100,0,300,32)
					random_touch(0, x, y , 30, 10) -- 58勾
					tired_op = nil
				elseif tired_op == "等待" then
					random_touch(0, 830, 175, 5, 5) -- 关闭
					HUD_show_or_hide(HUD,hud_info,"等待5分钟",20,"0xff000000","0xffffffff",0,100,0,300,32)
					mSleep(5*60*1000) -- 等待5分钟
					tired_op = nil
				elseif tired_op == "集结" then
					random_touch(0, 830, 175, 5, 5) -- 关闭
				elseif tired_op == "响铃" then
					alarm("exit") -- 提醒后退出脚本
				end
				break
			end
			-- 集结好友
			x, y = lct_sg_group()
			if x > -1 then
				HUD_show_or_hide(HUD,hud_info,"集结后等待5分钟",20,"0xff000000","0xffffffff",0,100,0,300,32)
				if sg_curr <= 4 then
					sg_group_invite() -- 邀请
				else
					sg_group_public() -- 公开
				end
				mSleep(5*60*1000) -- 等待5分钟
				tired_op = nil
				break
			end
			-- 超鬼王页面
			x, y = lct_sg_page()
			random_sleep(1000)
			if x > -1 then
				-- 进入集结
				if (tired_op == "集结") then
					ret = sg_group_check() -- Check是否可以集结
					if ret == RET_OK then
						random_touch(0, 880, 550, 10, 10) -- 集结
					else
						HUD_show_or_hide(HUD,hud_info,"等待5分钟",20,"0xff000000","0xffffffff",0,100,0,300,32)
						mSleep(5*60*1000) -- 等待5分钟
						tired_op = nil
					end
					break
				end
				-- 寻找超鬼王
				for index = 1, index_max do	-- 扫描区域1至区域1[Pri]/区域3[Pub]
					x_f, y_f, sg_curr = find_sg_mgt(index) -- 返回检测的Valid超鬼王的星级[sg_curr]
					if sg_curr > 0 then
						mSleep(500)
						random_touch(0, x_f+150, y_f, 60, 30) -- 选择超鬼王
						random_sleep(500)
						-- Pri模式下Check是否可以集结[没有集结->non-pri超鬼王]
						if sg_fight_sel == "Private" then
							ret = sg_group_check()
							if ret == RET_ERR then
								sg_curr = 0 -- 设置没有检测到Valid超鬼王然后退出扫描
								break
							end
						end
						-- Check是否可以挑战
						ret = sg_start()
						if ret == RET_OK then
							-- Check当前鬼王血条high/low
							sg_tb = find_sg_tb(index, sg_curr) -- 返回当前星级鬼王high/low操作string
							if sg_tb == "响铃" then
								alarm("pause")
							end
							if sg_tb == "集结" then
								tired_op = "集结"
								break
							end
							random_sleep(500)
							sg_switch_mode(sg_curr) -- 切换战斗模式
							random_touch(0, 1030, 540, 20, 20) -- 挑战
							break
						else
							HUD_show_or_hide(HUD,hud_info,string.format("区域%d鬼王已经结算", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
							mSleep(500)
							-- Pri模式下设置没有检测到Valid超鬼王然后退出扫描
							if sg_fight_sel == "Private" then
								sg_curr = 0
								break
							end
						end
					else
						HUD_show_or_hide(HUD,hud_info,string.format("区域%d未发现鬼王", index),20,"0xff000000","0xffffffff",0,100,0,300,32)
						mSleep(500)
						-- Pri模式下设置没有检测到Valid超鬼王然后退出扫描
						if sg_fight_sel == "Private" then
							sg_curr = 0
							break
						end
					end
				end
				if (sg_curr == 0) then
					if sg_keep == 1 then
						-- 超鬼王Portal进入时保持超鬼王函数持续运行
						HUD_show_or_hide(HUD,hud_info,"等待3分钟",20,"0xff000000","0xffffffff",0,100,0,300,32)
						mSleep(3*60*1000)
					else
						-- No valid超鬼王, 退出函数
						random_touch(0, 60, 55, 10, 10) -- 左上退出
						return RET_OK
					end
				end
			end
			-- 战斗准备/预设
			if sg_tb == "预设1" then
				x, y = fight_preset(1)
			elseif sg_tb == "预设2" then
				x, y = fight_preset(2)
			elseif sg_tb == "预设3" then
				x, y = fight_preset(3)
			else
				x, y = fight_ready()
			end
			if (x > -1) then sg_tb = nil break end
			-- 战斗失败
			x, y = fight_failed() if (x > -1) then break end
			-- 战斗胜利
			x, y = fight_success() if (x > -1) then break end
			-- 妖灵溢出
			x, y = sg_bonus_extra() if x > -1 then break end
			-- 领取奖励
			x, y = sg_bonus_get() if x > -1 then break end
			-- 退出奖励
			x, y = sg_bonus_exit() if x > -1 then break end
			break
		end
	end
	return RET_ERR
end