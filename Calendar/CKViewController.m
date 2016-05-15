#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"
#import "Masonry.h"

@interface CKViewController () <CKCalendarDelegate>

@property(nonatomic, strong) CKCalendarView *calendar;


@end

@implementation CKViewController

- (id)init {
    self = [super init];
    if (self) {
        _calendar = [[CKCalendarView alloc]initForAppointment];
        self.view.backgroundColor = [UIColor yellowColor];
        _calendar.delegate = self;
        _calendar.selectedDateFormatter = [[NSDateFormatter alloc] init];
        [_calendar.selectedDateFormatter setDateFormat:@"dd/MM/yyyy"];
        _calendar.minimumDate = [_calendar.selectedDateFormatter dateFromString:@"20/01/2016"];
        _calendar.maxmumDate = [_calendar.selectedDateFormatter dateFromString:@"20/07/2016"];
        _calendar.canSelectDates = [@[
                                [_calendar.selectedDateFormatter dateFromString:@"05/05/2016"],
                                [_calendar.selectedDateFormatter dateFromString:@"06/05/2016"],
                                [_calendar.selectedDateFormatter dateFromString:@"07/05/2016"]
                                ]copy];
        [self.view addSubview:_calendar];
        [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
//    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    NSLog(@"选中了某一天");
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end