#include <iostream>
#include <string>
#include <fstream>

#define y_min 1996
#define y_max 2020

using namespace std;

string s, front, filename = "City_Death.csv";

ifstream ifile(filename);
ofstream ofile(filename + " Edit" + ".csv");

void s_extract_front();
void s_to_num();
//�տ� 3 ���常 ���� ���� �ڿ� ���ڸ��� �������� y_min ���� y_max ���� ���� ���ļ� �տ� 3����� ���ؼ� ����Ѵ�.
int main()
{
	ofile << "cause," << "city," << "age," << "year," << "death," << endl;

	if (ifile.is_open()) {
		cout << "File ã�Ҵ�!" << endl << endl;

		while (!ifile.eof()) {
			s.clear();
			front.clear();
			getline(ifile, s);
			s_extract_front();
			s_to_num();
		}
	}
	else cout << "File Missing!" << endl;

	ifile.close();
	ofile.close();
}

void s_extract_front() {
	for (int i = 0; i < 3; i++) {
		front += s.substr(0, s.find(',')) + ",";
		s = s.replace(0, s.find(',') + 1, "");
	}
}

void s_to_num() {
	for (int i = 0; i < (y_max - y_min) + 1; i++) {
		cout << front << y_min + i << "," << s.substr(0, s.find(',')) << endl;
		ofile << front << y_min + i << "," << s.substr(0, s.find(',')) << endl;
		s = s.replace(0, s.find(',') + 1, "");
	}
	cout << endl;
}
