version(BML_CPP):

extern (C) {
alias int BulletMLParserTinyXML;
int* BulletMLParserTinyXML_new(const char*);
void BulletMLParserTinyXML_parse(int* );
void BulletMLParserTinyXML_delete(int*);
alias int BulletMLParser;
alias int BulletMLState;
alias int BulletMLRunner;
int* BulletMLRunner_new_parser(BulletMLParser*);
int* BulletMLRunner_new_state(BulletMLState*);
void BulletMLRunner_delete(int*);
void BulletMLRunner_run(int* );
bool BulletMLRunner_isEnd(int* );
void BulletMLRunner_set_getBulletDirection(int*, double function(int* ) fp); 
void BulletMLRunner_set_getAimDirection(int*, double function(int* ) fp); 
void BulletMLRunner_set_getBulletSpeed(int*, double function(int* ) fp); 
void BulletMLRunner_set_getDefaultSpeed(int*, double function(int* ) fp); 
void BulletMLRunner_set_getRank(int*, double function(int* ) fp); 
void BulletMLRunner_set_createSimpleBullet(int*, void function(int* , double, double) fp); 
void BulletMLRunner_set_createBullet(int*, void function(int* , BulletMLState*, double, double) fp); 
void BulletMLRunner_set_getTurn(int*, int function(int* ) fp); 
void BulletMLRunner_set_doVanish(int*, void function(int* ) fp); 
void BulletMLRunner_set_doChangeDirection(int*, void function(int* , double) fp); 
void BulletMLRunner_set_doChangeSpeed(int*, void function(int* , double) fp); 
void BulletMLRunner_set_doAccelX(int*, void function(int* , double) fp); 
void BulletMLRunner_set_doAccelY(int*, void function(int* , double) fp); 
void BulletMLRunner_set_getBulletSpeedX(int*, double function(int* ) fp); 
void BulletMLRunner_set_getBulletSpeedY(int*, double function(int* ) fp); 
void BulletMLRunner_set_getRand(int*, double function(int* ) fp); 
}