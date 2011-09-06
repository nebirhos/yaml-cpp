#include "yaml-cpp/conversion.h"
#include <algorithm>

////////////////////////////////////////////////////////////////
// Specializations for converting a string to specific types

namespace
{
	// we're not gonna mess with the mess that is all the isupper/etc. functions
	bool IsLower(char ch) { return 'a' <= ch && ch <= 'z'; }
	bool IsUpper(char ch) { return 'A' <= ch && ch <= 'Z'; }
	char ToLower(char ch) { return IsUpper(ch) ? ch + 'a' - 'A' : ch; }

	std::string tolower(const std::string& str)
	{
		std::string s(str);
		std::transform(s.begin(), s.end(), s.begin(), ToLower);
		return s;
	}

	template <typename T>
	bool IsEntirely(const std::string& str, T func)
	{
		for(std::size_t i=0;i<str.size();i++)
			if(!func(str[i]))
				return false;

		return true;
	}

	// IsFlexibleCase
	// . Returns true if 'str' is:
	//   . UPPERCASE
	//   . lowercase
	//   . Capitalized
	bool IsFlexibleCase(const std::string& str)
	{
		if(str.empty())
			return true;

		if(IsEntirely(str, IsLower))
			return true;

		bool firstcaps = IsUpper(str[0]);
		std::string rest = str.substr(1);
		return firstcaps && (IsEntirely(rest, IsLower) || IsEntirely(rest, IsUpper));
	}
}

namespace YAML
{
	bool Convert(const std::string& input, bool& b)
	{
		// we can't use iostream bool extraction operators as they don't
		// recognize all possible values in the table below (taken from
		// http://yaml.org/type/bool.html)
		static const struct {
			std::string truename, falsename;
		} names[] = {
			{ "y", "n" },
			{ "yes", "no" },
			{ "true", "false" },
			{ "on", "off" },
		};

		if(!IsFlexibleCase(input))
			return false;

		for(unsigned i=0;i<sizeof(names)/sizeof(names[0]);i++) {
			if(names[i].truename == tolower(input)) {
				b = true;
				return true;
			}

			if(names[i].falsename == tolower(input)) {
				b = false;
				return true;
			}
		}

		return false;
	}
	
	bool Convert(const std::string& input, _Null& /*output*/)
	{
		return input.empty() || input == "~" || input == "null" || input == "Null" || input == "NULL";
	}

	inline int base64size(const std::string& input)
	{
		int pad = 0, in_size = input.size();
		for (; input[in_size-1] == '='; pad++, in_size--) {}
		return ( in_size*6 - pad*2 ) / 8;
	}

	bool Convert(const std::string& input, BinaryInput& output)
	{
		const std::string base64_chars =
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			"abcdefghijklmnopqrstuvwxyz"
			"0123456789+/";

		int size = base64size(input);

		output._size = size;
		output._data = new unsigned char[size];

		unsigned char buffer[4];
		int block = 0;

		for (int i=0; i < input.size(); ++i) {
			char c = 0;
			if (input[i] != '=') {
				c = base64_chars.find( input[i] );
			}
			if (c == -1) {
				return false;
			}

			buffer[i % 4] = c;
			if ( (i % 4) == (3) ) {
				output._data[ block   ] = (buffer[0] << 2) + ((buffer[1] & 0x30) >> 4);
				output._data[ block+1 ] = ((buffer[1] & 0xf) << 4) + ((buffer[2] & 0x3c) >> 2);
				output._data[ block+2 ] = ((buffer[2] & 0x3) << 6) + buffer[3];
				block += 3;
			}
		}

		return true;
	}
}

