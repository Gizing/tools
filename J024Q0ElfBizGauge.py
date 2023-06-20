import re

last_line = None


def fetch_logic_line(log_file_obj, start_pattern, after_match):
    is_assemble = False
    ret_line = None
    while True:
        global last_line
        if last_line:
            line = last_line
            last_line = None
        else:
            line = log_file_obj.readline()
        if not line:
            break
        is_match = re.match(r"\[\d{4}-\d{2}-\d{2}]\[\d{2}:\d{2}:", line)
        if is_match is not None:
            # line start with timestamp
            if is_assemble:  # complete one logic line
                last_line = line
                break
            elif line.startswith(start_pattern):  # start of one logic line
                is_assemble = True
                ret_line = line
            elif after_match is True:  # the left content of file isn't satisfied, skip all
                break
            else:  # lines before match content, skip
                continue
        elif is_assemble:
            ret_line += line
        else:  # lines before match content, skip
            continue
    return ret_line


biz_gauge_dict = {}
biz_no_name_dict = {7777: "短信发送", 1111: "签约"}
log_file = "./app.log"
with open(log_file, 'r') as log_file:
    has_match = False
    while True:
        logic_line = fetch_logic_line(log_file, "[2023-06-19][21:01:", has_match)
        if not logic_line:
            break
        print(logic_line)
        match_obj = re.search(r"<transcd>(\d+)<transcd>", logic_line)
        if match_obj is not None:
            has_match = True
            trans_code = int(match_obj.group(1))
            biz_gauge_dict[trans_code] = biz_gauge_dict.get(trans_code, 0) + 1

    for biz_no, count in biz_gauge_dict.items():
        print("SHELL>%d|%s|%d" % (biz_no, biz_no_name_dict.get(biz_no, "unknown"), count))
